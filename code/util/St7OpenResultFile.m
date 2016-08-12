function St7OpenResultFile(uID, FilePath)

NumPrimary = 0;
NumSecondary = 0;
[iErr, NumPrimary, NumPrimary] = calllib('St7API', 'St7OpenResultFile', uID, FilePath, '', false, NumPrimary, NumSecondary);
HandleError(iErr);
    
end %St7OpenResultFile