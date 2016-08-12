function [U,freq] = getNFA(uID,rname,nmodes,ind)
% SYNTAX: [U,freq] = get_nfa(uID,rname,nmodes,ind)
% jdv 1/10/13; 1/29/13; 2/14/14;

    % update UI
    fprintf('\t NFA Analysis... \n'); 
    
    % setup - globals
    global stNaturalFrequencySolver smProgressRun kNodeDisp btTrue
    
    % set result file name 
    iErr = calllib('St7API', 'St7SetResultFileName', uID, rname);
    HandleError(iErr);
    
    % set number of modes to solve
    iErr = calllib('St7API','St7SetNFANumModes', uID, nmodes);
    HandleError(iErr);
    
    % run NFA solver
    iErr = calllib('St7API','St7RunSolver', uID, stNaturalFrequencySolver, smProgressRun, btTrue);
    HandleError(iErr);
    
    % open NFA result file
    [iErr, nPrimary, nSecondary] = calllib('St7API', 'St7OpenResultFile', uID, rname, '', false, 0, 0);
    HandleError(iErr);
    
    % Get frequencies
    freq = zeros(nmodes,1);
    for ii = 1:nmodes % loop solved modes
        [iErr, freq(ii,1)] = calllib('St7API','St7GetFrequency',uID,ii,1);
        HandleError(iErr);
    end
    
    % Get modeshapes
    fprintf('\t\tPopulating Mode Shapes... ');
    NodeRes = zeros(6,1);       % temporary 6DOF result for node jj
    nnodes = length(ind);       % number of nodes to fetch
    U = zeros(nnodes, nmodes);  % result mode shape matrix
    for ii = 1:nmodes           % loop solved modes
        for jj = 1:nnodes       % loop stored plate nodes; gdata.nodeInd(jj)    
            % index selected dof
            [iErr, NodeRes] = calllib('St7API', 'St7GetNodeResult', uID, kNodeDisp,...
                                        ind(jj), ii, NodeRes);
            HandleError(iErr); 
            % Save vertical (Z) node disp
            U(jj,ii) = NodeRes(3); 
        end
    end
    
    % clean up
    iErr = calllib('St7API','St7CloseResultFile',uID);
    HandleError(iErr);
    
    % update UI
    fprintf(' Done. \nDone.');
end