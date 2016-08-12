function [U,freq,modalres] = getNFA(uID,rname,nmodes,ind)
%% SYNTAX: [U,freq] = getNFA(uID,rname,nmodes,ind)
%
%
% input:
%   rname   - result name
%   nmodes  - number of modes to return
%   nmodes  - number of modes to solve        
%   ind     - strand7 node index for global modes
% 		
% output:
%   U       - mode shape array of size [nNodes x 6 DOF x nModes]
%   freq    - undamped natural freqs [hz]
%   modalres - st7 modal results
%
%
% jdv 1/10/13; 1/29/13; 2/14/14; 08122016;
    fprintf('\t NFA Analysis... \n'); 
    
    % setup - globals
    global stNaturalFrequencySolver smProgressRun kNodeDisp btTrue
    
    % set result file name 
    iErr = calllib('St7API', 'St7SetResultFileName', uID, rname);
    HandleError(iErr);
    
    % set number of modes to solve
    iErr = calllib('St7API','St7SetNFANumModes', uID, nmodes);
    HandleError(iErr);
    
    % set mode participation calculation
    iErr = calllib('St7API','St7SetNFAModeParticipationCalculate', uID, btTrue);
    HandleError(iErr);
    
    % run NFA solver
    iErr = calllib('St7API','St7RunSolver', uID, stNaturalFrequencySolver, smProgressRun, btTrue);
    HandleError(iErr);
    
    % open NFA result file
    [iErr, nPrimary, nSecondary] = calllib('St7API', 'St7OpenResultFile', uID, rname, '', false, 0, 0);
    HandleError(iErr);
    
    % Get frequencies and modalresults
    freq = zeros(nmodes,1);
    modalres = zeros(nmodes,10);
    for ii = 1:nmodes % loop solved modes
        
        % get natural frequency
        [iErr, freq(ii,1)] = calllib('St7API','St7GetFrequency',uID,ii,1);
        HandleError(iErr);
        
        % get modal results (e.g. modal mass, modal stiffness)
        [iErr,modalres(ii,:)] = calllib('St7API','St7GetModalResultsNFA',uID,...
            ii,modalres(ii,:));
        HandleError(iErr);
    end
    
    % Get modeshapes
    fprintf('\t\tPopulating Mode Shapes... ');
    NodeRes = zeros(6,1);       % temporary 6DOF result for node jj
    nnodes = length(ind);       % number of nodes to fetch
    U = zeros(nnodes,6,nmodes); % result mode shape matrix
    for ii = 1:nmodes           % loop solved modes
        for jj = 1:nnodes       % loop stored plate nodes; gdata.nodeInd(jj)    
            % index selected dof
            [iErr, NodeRes] = calllib('St7API', 'St7GetNodeResult', uID, kNodeDisp,...
                                        ind(jj), ii, NodeRes);
            HandleError(iErr); 
            U(jj,:,ii) = NodeRes; 
        end
    end
    
    
    
    % clean up
    iErr = calllib('St7API','St7CloseResultFile',uID);
    HandleError(iErr);
    
    % update UI
    fprintf(' Done. \nDone.');
end