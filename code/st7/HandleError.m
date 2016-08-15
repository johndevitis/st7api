function HandleError(iErr)
% Helper to convert ST7API error codes to MATLAB errors
global kMaxStrLen ERR7_NoError
    if (iErr~=ERR7_NoError)
        str = char(zeros(kMaxStrLen, 1));
        [iNewErr, str] = calllib('St7API', 'St7GetAPIErrorString', iErr, str, kMaxStrLen);
        if (iNewErr>0)
            [iNewErr, str] = calllib('St7API', 'ST7GetSolverErrorString', iErr ,str, kMaxStrLen);
        end
        % Issue as a MATLAB error
        error(['St7API error: ', str]);
    end
end % /HandleError()