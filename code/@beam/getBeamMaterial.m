function mat = getBeamMaterial(self, uID)
%% getBeamMaterial
% 
% 
% 
% author: John Braley
% create date: 08-Sep-2016 15:55:07
	
% Handle zero entry
if nargin<2; uID = 1; end

% Preallocate output variables
MatData = zeros(1,9);

% Beam Strand7 property identifier
propNum = self.propNum;

% set material data for Strand7 beam property
[iErr, MatData] = calllib('St7API','St7GetBeamMaterialData',uID,propNum,...
    MatData);
HandleError(iErr)

mat = material();
mat.E = MatData(1); % Modulus
% mat.shearmod = MatData(2); % Shear modulus
mat.poisson = MatData(3); % Poisson's Ratio
mat.density = MatData(4); % Density
mat.thermalexp = MatData(5); % Thermal expansion coefficient
mat.damping = MatData(6); % Viscous Damping coefficient
mat.dampR = MatData(7); % Damping Ratio
mat.thermalcond = MatData(8); % Thermal conductivity coefficient
mat.heat = MatData(9); % Specific heat coefficient
	
end
