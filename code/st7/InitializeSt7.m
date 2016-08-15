function InitializeSt7()

St7APIConst();

    if ~libisloaded('St7API')
        % Load the api of not already loaded
        fprintf('Loading ST7API.DLL... ');
        loadlibrary('St7API.dll', 'St7APICall.h');
        iErr = calllib('St7API', 'St7Init');
        HandleError(iErr);
        fprintf('Done \n');
    end

end