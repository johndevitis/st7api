function res = get_lsa(uID,rname,load_lc,load_ind,load_force,resp_lc,resp_ind)
% assign static load by index
% jdv 7/9/14; 1/11/15

    % globals
    global stLinearStaticSolver smProgressRun btTrue rtNodeDisp

    % update user
    fprintf('\tRunning Linear Static Analysis... ');

    % set result file name 
    iErr = calllib('St7API', 'St7SetResultFileName', uID, rname);
    HandleError(iErr);

    % Assign force 
    % - loop load index for force assignment indices. assign to load case
    for ii = 1:length(load_ind)
        iErr = calllib('St7API', 'St7SetNodeForce3', uID, load_ind(ii),...
            load_lc(ii), load_force(ii,:));
        HandleError(iErr);
    end
    
    % enable load case - default freedom case 1
    lc = unique(load_lc);
    for ii = 1:length(lc);
        iErr = calllib('St7API','St7EnableLSALoadCase', uID, lc(ii), 1);
        HandleError(iErr);
    end

    % run lsa solver
    iErr = calllib('St7API','St7RunSolver', uID, stLinearStaticSolver, ...
        smProgressRun, btTrue);
    HandleError(iErr);
    
    % disable load case
    for ii = 1:length(lc);
        iErr = calllib('St7API','St7DisableLSALoadCase', uID, lc(ii), 1);
        HandleError(iErr);
    end

    % open results
    [iErr, nPrimary, nSecondary] = calllib('St7API', 'St7OpenResultFile',...
        uID, rname, '', false, 0, 0);
    HandleError(iErr);

    % Gather Results
    res = zeros(length(resp_ind),6);

    % loop response index for requested results
    for ii = 1:length(res)
        [iErr,res(ii,:)] = calllib('St7API', 'St7GetNodeResult', uID,...
            rtNodeDisp, resp_ind(ii), resp_lc(ii), [0 0 0 0 0 0]);
        HandleError(iErr);
    end

    % clean up
    iErr = calllib('St7API','St7CloseResultFile',uID);
    HandleError(iErr);
    
    % update user
    fprintf('Done.\n');
end