function results = apish(main,model,opts)
%% Self-contained API execution wrapper
% SYNTAX: model = apish(main,model)
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
% note:
%  * apish.m and the main function should be at least at the same folder
%  level as the classdef folders
%
%
% jdv 09212015; 10281015; 10292015; 08142016
    uID = 1; % default session id
    try % execute main fcn in try/catch
        % load libs and models
        apiInit(uID,model(1).sys); 
        % main fcn
        for ii = 1:length(model)
            results(ii) = main(uID,model(ii));
        end
        
        % load default options if none provided
        if nargin < 3
            opts = apiOptions();
        end
        
        % check whether or not to unload library
        if opts.keepLoaded == 0
            CloseAndUnload(uID);
        elseif opts.keepOpen == 0
            api.closeModel(uID)     
        end
        
    catch % force close close all refs
        fprintf('Force close');
        CloseAndUnload(uID);
        rethrow(lasterror);
    end
end 

function apiInit(uID,para)
%% initialize api fcn
    % load api files
    fprintf('Loading ST7API.DLL... ');
    St7APIConst(); % load constants
    if ~libisloaded('St7API')
        loadlibrary('St7API.dll', 'St7APICall.h');
        iErr = calllib('St7API', 'St7Init');
        HandleError(iErr);
    end
    % open st7 model file
    fname = fullfile(para.pathname, para.filename); 
    sname = para.scratchpath;
    iErr = calllib('St7API', 'St7OpenFile', uID, fname, sname);
    HandleError(iErr);
    fprintf('Done. \n');
end 

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
end 

function CloseAndUnload(uID)
% Close any open files associated with uID and unload the St7API.
    % tell user of action
    fprintf('\nExiting API... ');
    % close any open result files
    calllib('St7API','St7CloseResultFile', uID);
    % close st7 model file 
    calllib('St7API','St7CloseFile',uID);
    % unload lib
    unloadlibrary('St7API');
    % update complete
    fprintf(' Done\n');
end  

