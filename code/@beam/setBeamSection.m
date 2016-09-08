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
sectionData = [self.section.area... % Area
    self.section.I11... % Second moment of area about the principal 1 axis
    self.section.I22... % Second moment of area about the principal 2 axis
    self.section.J... % Torsion constant
    self.section.SL1... % Shear center offset in the principle 1 axis
    self.section.SL2... % Shear center offset in the principle 2 axis
    self.section.SA1... % Shear area in the princliple 1 axis
    self.section.SA2... % Shear area in the principle 2 axis
    self.section.XBAR... % Centroid offset in the principle 1 axis
    self.section.YBAR... % Centroid offset in the principle 2 axis
    self.section.ANGLE]; % Principle axis angle
	
% Integration slices
int = 5;

% Beam Strand7 property identifier
propNum = self.beamID;

% set material data for Strand7 beam property
iErr = calllib('St7API','St7SetBeamSectionPropertyData',uID,propNum,...
    int, sectionData);
HandleError(iErr)
	
	
end