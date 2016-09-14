function mat = getPlateMaterial(self,uID)
%% getPlateMaterial
% 
% 
% 
% author: John Braley
% create date: 13-Sep-2016 17:06:57
	
% Handle zero entry
if nargin<2; uID = 1; end

% Preallocate output variables
MatData = zeros(1,8);

% Beam Strand7 property identifier
propNum = self.propNum;

% set material data for Strand7 beam property
[iErr, MatData] = calllib('St7API','St7GetPlateIsotropicMaterial',uID,propNum,...
    MatData);
HandleError(iErr)

mat = material();
mat.E = MatData(1); % Modulus
mat.poisson = MatData(2); % Poisson's Ratio
mat.density = MatData(3); % Density
mat.thermalexp = MatData(4); % Thermal expansion coefficient
mat.damping = MatData(5); % Viscous Damping coefficient
mat.dampR = MatData(6); % Damping Ratio
mat.thermalcond = MatData(7); % Thermal conductivity coefficient
mat.heat = MatData(8); % Specific heat coefficient	
	
	
	
end
