function runNFA(self,uID,nodeInd)
%% SYNTAX: self.getNFA(uID,nodeInd)
%
% nfa.runNFA(uID,nodeInd*) does the following: 
%
% 1. sorts which nodes to calculate 
%   * when given a vector, nodeInd, it will pull results for each st7node
%   index included
%   * when not given node indices, runNFA will call api.getTotalNodes() to
%   get full list of nodes present in model
% 2. set result file name
% 3. set number of modes to calcualte
% 4. set mode participation calculation
% 5. run nfa solver in background
% 6. open nfa result file
% 7. get frequencies and modal results
% 8. get nodal results (mode shapes) 
% 9. close result file
%
%
% output:
%   U       - mode shape array of size [nNodes x 6 DOF x nModes]
%   freq    - undamped natural freqs [hz]
%   modalres - st7 modal results
%

%
% jdv 1/10/13; 1/29/13; 2/14/14; 08122016; 08162016
    % setup - globals
    global stNaturalFrequencySolver smBackgroundRun kNodeDisp btTrue
      
    % create nodeInd if not provided
    if nargin < 3
        nnodes = api.getTotalNodes(uID); % get total number of nodes
        self.nodeid = 1:nnodes;          % form full node index
    else % userinput
        self.nodeid = nodeInd;
        nnodes = length(nodeInd); % get number of nodes to fetch
    end
    
    fprintf('\t NFA Analysis... \n'); 
    
    % set result file name 
    iErr = calllib('St7API','St7SetResultFileName',uID,self.name);
    HandleError(iErr);
    
    % set number of modes to solve
    iErr = calllib('St7API','St7SetNFANumModes',uID,self.nmodes);
    HandleError(iErr);
    
    % set mode participation calculation
    iErr = calllib('St7API','St7SetNFAModeParticipationCalculate',uID,...
        btTrue);
    HandleError(iErr);
    
    % run NFA solver
    iErr = calllib('St7API','St7RunSolver', uID, stNaturalFrequencySolver,...
        smBackgroundRun,btTrue);
    HandleError(iErr);
    
    % open NFA result file
    [iErr, nPrimary, nSecondary] = calllib('St7API','St7OpenResultFile',...
        uID,self.name,'',false,0,0);
    HandleError(iErr);
    
    % Get frequencies and modalresults
    freq = zeros(self.nmodes,1);
    modalres = zeros(self.nmodes,10);
    for ii = 1:self.nmodes % loop solved modes        
        % get natural frequency
        [iErr,self.freq(ii,1)] = calllib('St7API','St7GetFrequency',uID,ii,1);
        HandleError(iErr);        
        % get modal results (e.g. modal mass, modal stiffness)
        [iErr,self.modal(ii,:)] = calllib('St7API','St7GetModalResultsNFA',...
            uID,ii,modalres(ii,:));
        HandleError(iErr);
    end
    
    % Get modeshapes
    fprintf('\t\tPopulating Mode Shapes... ');
    NodeRes = zeros(6,1);       % temporary 6DOF result for node jj
    self.U = zeros(nnodes,6,self.nmodes); % result mode shape matrix
    for ii = 1:self.nmodes      % loop solved modes
        for jj = 1:nnodes       % loop stored nodes
            % index selected dof
            [iErr, NodeRes] = calllib('St7API', 'St7GetNodeResult', uID,...
                kNodeDisp, self.nodeid(jj), ii, NodeRes);
            HandleError(iErr); 
            % save to U [nnodes x 6dof x nmodes]
            self.U(jj,:,ii) = NodeRes; 
        end
    end
    fprintf('Done.');
    
    % clean up
    iErr = calllib('St7API','St7CloseResultFile',uID);
    HandleError(iErr);
    

end