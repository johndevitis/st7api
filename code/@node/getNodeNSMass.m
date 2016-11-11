function mass = getNodeNSMass(self,uID,LC)
%% getNodeNSMass
% 
% 
% 
% author: John Braley
% create date: 09-Nov-2016 12:54:38
	
    if nargin<3; LC = 1; end
    if nargin<2; uID = 1; end

    for ii=1:length(self.id)
        mass = zeros(1,5);
        % Add structural mass to nodes
        [iErr, mass] = calllib('St7API', 'St7GetNodeNSMass5', uID, self.id(ii), LC, mass);
        % Check for no assigned mass
        if iErr==10
            mass = zeros(1,5);	
        end
    end	
	
end
