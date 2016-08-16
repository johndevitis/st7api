function nnodes = getTotalNodes(uID)
%% getTotalNodes
% 
% returns the total nodes found in uID
% 
% author: john devitis
% create date: 16-Aug-2016 13:40:50
	global tyNODE
    [iErr,nnodes] = calllib('St7API','St7GetTotal',uID,tyNODE,0);
    HandleError(iErr);
end
