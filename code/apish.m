function apish(main,sys,model,opts,objectName)
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
% objectName - string describing which field in model structure to be
%               passed into main function
% note:
%  * apish.m and the main function should be at least at the same folder
%  level as the classdef folders
%
%
% jdv 09212015; 10281015; 10292015; 08142016


    try % execute main fcn in try/catch
        % load libs and models
        uID = sys.uID;
        apiInit(uID,sys); 
        % main fcn
        if isa(model,'cell')
            main(uID,model);
        else
            for ii = 1:length(model)
                main(uID,model(ii));
            end
        end
        
        
        % load default options if none provided
        if nargin < 4
            opts = apiOptions();
        end
        
        % check whether or not to unload library
        if opts.keepLoaded == 0
            CloseAndUnload(uID);
            sys.open=0;
        elseif opts.keepOpen == 0
            api.closeModel(uID)
            sys.open=0;
        end
        
    catch % force close close all refs
        fprintf('Force close');
        CloseAndUnload(uID);
        sys.open=0;
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
    if para.open==0 || isempty(para.open)
        fname = fullfile(para.pathname, para.filename); 
        sname = para.scratchpath;
        iErr = calllib('St7API', 'St7OpenFile', uID, fname, sname);
        HandleError(iErr);
        para.open=1;
        fprintf('Done. \n');
    end        
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

