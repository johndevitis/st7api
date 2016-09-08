function section = getBeamSection(self, uID)
%% getBeamSection
% 
% 
% 
% author: John Braley
% create date: 08-Sep-2016 14:27:36
	
% Handle zero entry
if nargin<2; uID = 1; end

% Preallocate output variables
sectionData = zeros(1,11);
int = 0;

% Beam Strand7 property identifier
propNum = self.propNum;

% Retrieve section data from strand7 model
[iErr, int, sectionData]  = calllib('St7API','St7SetBeamSectionPropertyData',uID,propNum,...
    int, sectionData);
HandleError(iErr)

%% Populate section structure with data
section.area = secData(1);
section.I11 = sectionData(2);
section.I22 = sectionData(3);
section.J = sectionData(4);
section.SL1 = sectionData(5);
section.SL2  = sectionData(6);
section.SA1 = sectionData(7);
section.SA2 = sectionData(8);
section.XBAR = sectionData(9);
section.YBAR = sectionData(10);
section.ANGLE = sectionData(11);

% self.section = section;	
	
end
