function setPlateMaterial(self, uID)
%% setPlateMaterial
% 
% 
% 
% author: John Braley
% create date: 13-Sep-2016 17:07:22
	
% Handle zero entry
if nargin<2; uID = 1; end

%% Create material properties vector
MatData = ...
    [self.E ...             % Modulus
    self.poisson ...        % Poisson's Ratio
    self.density ...        % Density
    self.thermalexp ...     % Thermal Expansion
    self.damping ...        % Viscous damping
    self.dampR ...          % damping ratio
    self.thermalcond ...    % thermal conductivity
    self.heat];             % specific heat
	
% Beam Strand7 property identifier
propNum = self.propNum;

% Loop through all the properties
for ii = 1:length(propNum)
% set material data for Strand7 beam property
iErr = calllib('St7API','St7SetPlateIsotropicMaterial',uID,propNum(ii),...
    MatData);
HandleError(iErr)	
end
	
	
end
