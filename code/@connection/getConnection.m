function stiff = getConnection(self, uID)
%% getBeamSection
% 
% 
% 
% author: John Braley
% create date: 24-Oct-2016 
	
% Handle zero entry
if nargin<2; uID = 1; end

% Preallocate output variables
stiffness = zeros(1,6);

% Beam Strand7 property identifier
propNum = self.propNum;

% Retrieve section data from strand7 model (FIRST propNum)
[iErr, stiffness]  = calllib('St7API','St7GetConnectionData',uID,propNum(1),...
    stiffness);
HandleError(iErr)

stiff.Xstif = stiffness(1); % translational stiffness. 3 element array: 1,2,3 element axes
stiff.Ystif = stiffness(2); % translational stiffness. 3 element array: 1,2,3 element axes
stiff.Zstif = stiffness(3); % translational stiffness. 3 element array: 1,2,3 element axes
stiff.Rstiffness = stiffness(4:6); % rotational stiffness. 3 element array: 4,5,6 element axes

	
end
