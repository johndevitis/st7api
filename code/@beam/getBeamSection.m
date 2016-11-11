function sxn = getBeamSection(self, uID)
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

% Retrieve section data from strand7 model (FIRST propNum)
[iErr, int, sectionData]  = calllib('St7API','St7GetBeamSectionPropertyData',uID,propNum(1),...
    int, sectionData);
HandleError(iErr)

%% Populate section structure with data
sxn = section();
sxn.A = sectionData(1);
sxn.I11 = sectionData(2);
sxn.I22 = sectionData(3);
sxn.J = sectionData(4);
sxn.SL1 = sectionData(5);
sxn.SL2  = sectionData(6);
sxn.SA1 = sectionData(7);
sxn.SA2 = sectionData(8);
sxn.XBAR = sectionData(9);
sxn.YBAR = sectionData(10);
sxn.ANGLE = sectionData(11);

% self.section = section;	
	
end
