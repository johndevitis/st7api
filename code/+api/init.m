function init()
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