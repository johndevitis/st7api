%% --- API Execution Wrapper --- %%
function model = apish(model)
%% Self-contained API execution wrapper
% function model = apish(model)
%
% default wrapper for handling API errors. can be used to copy/paste into a
% project for quick api work
%
%
% model.
% 	sys.
% 		pathname - root path
% 		filename - fe model file name
% 		scratchpath - st7 tempo dir
%
% jdv 09212015; 10281015; 10292015
    uID = 1; % default session id
    try % execute main fcn in try/catch
        % load libs and models
        apiInit(uID,model.sys); 
        % main fcn
        model = main(uID,model);
        % close model file
        CloseAndUnload(uID);      
    catch % force close close all refs
        CloseAndUnload(uID);
        rethrow(lasterror);
    end
end 


function apiInit(uID,para)
%% initialize api fcn
    fprintf('Initializing API... \n'); 
    % load api files
    fprintf('\tLoading ST7API.DLL... ');
    St7APIConst(); % load constants
    if ~libisloaded('St7API')
        loadlibrary('St7API.dll', 'St7APICall.h');
        iErr = calllib('St7API', 'St7Init');
        HandleError(iErr);
    end
    fprintf('Done. \n'); 
    % open st7 model file
    fname = fullfile(para.pathname, para.filename); 
    sname = para.scratchpath;
    iErr = calllib('St7API', 'St7OpenFile', uID, fname, sname);
    HandleError(iErr);
    % update
    fprintf('Done. \n');
end 





%% Utility Functions
function HandleError(iErr)
% Helper to convert ST7API error codes to MATLAB errors
global kMaxStrLen ERR7_NoError
    if (iErr~=ERR7_NoError)
        str = char(zeros(kMaxStrLen, 1));
        [iNewErr, str] = calllib('St7API', 'St7GetAPIErrorString', iErr, str, kMaxStrLen);
        if (iNewErr>0)
            [~, str] = calllib('St7API', 'ST7GetSolverErrorString', iErr ,str, kMaxStrLen);
        end
        % Issue as a MATLAB error
        error(['St7API error: ', str]);
    end
end % /HandleError()

function CloseAndUnload(uID)
% Close any open files associated with uID and unload the St7API.
    % tell user of action
    fprintf('Exiting API... ');
    % close any open result files
    calllib('St7API','St7CloseResultFile', uID);
    % close st7 model file 
    calllib('St7API','St7CloseFile',uID);
    % unload lib
    unloadlibrary('St7API');
    % update complete
    fprintf(' Done\n');
end  % /CloseAndUnload()

