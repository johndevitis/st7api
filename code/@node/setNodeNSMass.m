function setNodeNSMass(self,uID,LC)
%% setNodeNSMass
% 
% 
% 
% author: John Braley
% create date: 13-Sep-2016 16:08:16
	
    if nargin<3; LC = 1; end
    if nargin<2; uID = 1; end

    for ii=1:length(self.id)
        Doubles = [self.Mns 1 0 0 0];
        % Add structural mass to nodes
        iErr = calllib('St7API', 'St7SetNodeNSMass5', uID, self.id(ii), LC, Doubles);
        HandleError(iErr);	
    end
	
	
	
end
