function save(uID)
%% save strand7 model file
% 
% 
% 
% author: john devitis
% create date: 18-Aug-2016 12:22:37
	iErr = calllib('St7API','St7SaveFile',uID);
    HandleError(iErr);	
end
