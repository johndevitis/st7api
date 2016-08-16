function openModel(uID, PathName, FileName, ScratchPath)
    % error screen missing file extension
    if isempty(regexp(FileName,'.st7','once'))
       % ext missing, add
       FileName = [FileName '.st7'];   
    end
    % call fullfile to sort path\name conflicts
    ModelPathName = fullfile(PathName, FileName);

    % open and handle error
    iErr = calllib('St7API', 'St7OpenFile', uID, ModelPathName, ScratchPath);
    HandleError(iErr);
end