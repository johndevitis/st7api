function newfcase(self,names)
%% newfcase
% 
% names - nx1 cell array of strings
% 
% author: John Braley
% create date: 15-Nov-2016 10:37:55
	
if nargin<2 
    names{1} = 'newfcase'; end

for ii = 1:length(names)
    iErr = calllib('St7API','St7NewFreedomCase',self.uID,names{ii});
        HandleError(iErr);
end
	
	
	
end
