function getUCSinfo(self,uID,id)
%% getUCSinfo
% 
% 
% 
% author: john devitis
% create date: 12-Aug-2016 18:07:14

    if nargin < 3
        id = 1;
    end
    % get ucsid from index
    [iErr,ucsid] = calllib('St7API','St7GetUCSID',uID,id,1);
    HandleError(iErr);

    % get ucs name
    [iErr,ucsname] = calllib('St7API','St7GetUCSName',uID,ucsid,'hi',...
        50);
    HandleError(iErr);
    
    self.ucsid = ucsid;
    self.ucsname = {ucsname};
	
end
