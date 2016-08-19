function closeModel(uID)
%% closeModel
% 
% 
% 
% author: 
% create date: 19-Aug-2016 10:59:52
	if nargin > 0
        calllib('St7API','St7CloseFile',uID);
    end	
end
