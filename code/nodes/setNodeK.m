function setNodeK(uID,nodes,fcasenum,ucsid,Kt,Kr)
%% setNodeK
% 
% Sets the rotational stiffness acting at the specified node
% 
% nodes:
%   strand7 node index
%
% casenum:
%   load case number
%
% USCid: 
%   The ID number for the specified UCS
%
% Kt:
%   A 3 element array describing the translational stiffnesses for the specified
%   node.  Doubles[i-1] describes the stiffness for the i th translational DoF
%   according to the 123 axis definition in the specified UCS.
%
% Kr:
%   A 3 element array describing the rotational stiffnesses for the specified node.
%   Doubles[i-1] describes the stiffness for the i th rotational DoF according to
%   the 456 axis definition in the specified UCS.
%   
% 
% author: john devitis
% create date: 12-Aug-2016 11:23:37
	
	% translation
    if nargin > 4
        if ~isempty(Kt)
            for ii = 1:length(nodes)
                iErr = calllib('St7API','St7SetNodeKTranslation3F',uID,nodes(ii),...
                    fcasenum(ii),ucsid(ii),Kt(ii,:));
                HandleError(iErr);
            end
        end
    end
    
    % rotation
    if nargin > 5
        for ii = 1:length(nodes)
            iErr = calllib('St7API','St7SetNodeKRotation3F',uID,nodes(ii),...
                fcasenum(ii),ucsid(ii),Kr(ii,:));
            HandleError(iErr);
        end
    end
	
end
