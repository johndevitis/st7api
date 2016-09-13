function setBeamSection(self, uID)
%% setBeamSection
% 
% 
% 
% author: John Braley
% create date: 08-Sep-2016 14:08:07
	
% Handle zero entry
if nargin<2; uID = 1; end

%% Populate Section Data vector
sectionData = [self.A... % Area
    self.I11... % Second moment of area about the principal 1 axis
    self.I22... % Second moment of area about the principal 2 axis
    self.J... % Torsion constant
    self.SL1... % Shear center offset in the principle 1 axis
    self.SL2... % Shear center offset in the principle 2 axis
    self.SA1... % Shear area in the princliple 1 axis
    self.SA2... % Shear area in the principle 2 axis
    self.XBAR... % Centroid offset in the principle 1 axis
    self.YBAR... % Centroid offset in the principle 2 axis
    self.ANGLE]; % Principle axis angle
	
% Integration slices
int = 5;

% Beam Strand7 property identifier
propNum = self.propNum;

% set material data for Strand7 beam property
iErr = calllib('St7API','St7SetBeamSectionPropertyData',uID,propNum,...
    int, sectionData);
HandleError(iErr)
	
	
end