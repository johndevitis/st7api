function closeAll(uID)
% Close any open files associated with uID and unload the St7API.
    % tell user of action
    fprintf('Exiting API... ');
    if nargin > 0
        % close any open result files
        calllib('St7API','St7CloseResultFile', uID);
        % close st7 model file 
        calllib('St7API','St7CloseFile',uID);
    end
    % unload lib
    unloadlibrary('St7API');
    % update complete
    fprintf(' Done\n');
end