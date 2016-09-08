function setBeamMaterial(self, uID)
%% setBeamMaterial
% 
% 
% 
% author: John Braley
% create date: 08-Sep-2016 13:52:55

% Handle zero entry
if nargin<2; uID = 1; end

%% Create material properties vector
MatData = ...
    [self.E ... % Modulus
    self.shearmod ... % Shear Modulus
    self.poisson ... % Poisson's Ratio
    self.density ... % Density
    self.thermalexp ... % Thermal Expansion
    self.damping ... % Viscous damping
    self.dampR ... % damping ratio
    self.thermalcond ... % thermal conductivity
    self.heat]; % specific heat
	
% Beam Strand7 property identifier
propNum = self.propNum;

% set material data for Strand7 beam property
iErr = calllib('St7API','St7SetBeamMaterialData',uID,propNum,...
    MatData);
HandleError(iErr)
	
	
end
