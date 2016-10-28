function saveas(uID, PathName, FileName)
%% saveas
% 
% 
% 
% author: John Braley
% create date: 28-Oct-2016 15:03:15

% error screen missing file extension
if isempty(regexp(FileName,'.st7','once'))
   % ext missing, add
   FileName = [FileName '.st7'];   
end
% call fullfile to sort path\name conflicts
ModelPathName = fullfile(PathName, FileName);

iErr = calllib('St7API', 'St7SaveFileTo', uID, ModelPathName);
HandleError(iErr);		
	
end
