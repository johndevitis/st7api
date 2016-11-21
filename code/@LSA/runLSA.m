function runLSA(self,uID)
%% assign static load by nodeid and run lsa solver
%
% inputs:
% fcase     - freedom case, defaults to 1
%
% 1. checks for empty outputid, defaults to output all
% 2. sets the result file name
% 3. loops self.nodeid and sets the force using nodeid, lcase, force combo1
% 4. enables all load cases in self.lcase
% 5. runs the solver
% 6. disables the previous load case enabling
% 7. opens result file 
% 8. gets node result at self.outputid
% 9. 
% 
% 
% jdv 7/9/14; 1/11/15; 08232016

    % globals
    global stLinearStaticSolver smProgressRun btTrue rtNodeDisp   
    
    % error screen null output index
    if isempty(self.outputid)
        % get all the nodes
        self.outputid = api.getTotalNodes(uID);
        self.outputcase = ones(size(self.outputid));
    end
    
%% Unique result file logic wrapper here    
    % check if unique result name in path
    self.isuniquefile    
    % if result file does not already exist
    if self.unique
        % update user
        fprintf('\tRunning Linear Static Analysis... \n');

        % set result file name 
        iErr = calllib('St7API','St7SetResultFileName',uID,self.fullname);
        HandleError(iErr);

        % Assign force 
        % - loop load index for force assignment indices. assign to load case
        for ii = 1:length(self.inputid)
            iErr = calllib('St7API','St7SetNodeForce3',uID,self.inputid(ii),...
                self.inputcase(ii),self.force(ii,:));
            HandleError(iErr);
        end

        % Assign moment -- ADD ME PLEASE --


        % enable all load cases in lsa object
        [lc,ind] = unique(self.inputcase);

        for ii = 1:length(lc);
            if min(size(self.fcase))==1
                % all fcases enabled for each load case
                fc = self.fcase;
            else
                % unique fcase combination for each load case
                fc = self.fcase(:,ind(ii));
            end
            for jj = 1:length(fc)
                iErr = calllib('St7API','St7EnableLSALoadCase',uID,lc(ii),...
                    fc(jj));
                HandleError(iErr);
            end
        end

        % run lsa solver
        iErr = calllib('St7API','St7RunSolver',uID,stLinearStaticSolver, ...
            smProgressRun, btTrue);
        HandleError(iErr);

        % disable load case
        for ii = 1:length(lc);
            iErr = calllib('St7API','St7DisableLSALoadCase',uID,lc(ii),...
                self.fcase(ind));
            HandleError(iErr);
        end
    end %% End Logic wrapper here
% End Logic wrapper here
    
%% Open result file
    if ~isempty(self.outputcase)
        % open results
        [iErr, nPrimary, nSecondary] = calllib('St7API', 'St7OpenResultFile',...
            uID, self.fullname, '', false, 0, 0);
        HandleError(iErr);

        % Gather Results
        self.resp = zeros(length(self.outputid),6);

        % loop response index for requested results
        for ii = 1:size(self.resp,1)
            [iErr,self.resp(ii,:)] = calllib('St7API','St7GetNodeResult',uID,...
                rtNodeDisp,self.outputid(ii),self.outputcase(ii),[0 0 0 0 0 0]);
            HandleError(iErr);
        end

        % clean up
        iErr = calllib('St7API','St7CloseResultFile',uID);
        HandleError(iErr);
    end
    
    % update user
    fprintf('Done. ');
end