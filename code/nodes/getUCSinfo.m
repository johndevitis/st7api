function [ucsid, ucsname] = getUCSinfo(uID,nodes)
%% getUCSinfo
% 
% 
% 
% author: john devitis
% create date: 12-Aug-2016 18:07:14
	
    % default ucs index = 1 = Global XYZ
    ind = 1; 
    ucsid = zeros(size(nodes));
    ucsname = cell(size(nodes));
    for ii = 1:length(nodes)
        % get ucs id
        ind = 1; % ucs index = 1 = Global XYZ
        [iErr,ucsid(ii)] = calllib('St7API','St7GetUCSID',uID,ind,1);
        HandleError(iErr);

        % get ucs name
        [iErr,ucsname{ii}] = calllib('St7API','St7GetUCSName',uID,ucsid(ii),'hi',...
            50);
        HandleError(iErr);
    end
	
end
