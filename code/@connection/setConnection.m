function setConnection(self, uID)
%% setBeamSection
% 
% 
% 
% author: John Braley
% create date: 24-Oct-2016 
	
% Handle zero entry
if nargin<2; uID = 1; end

%% Populate Section Data vector
stiffness = [self.Tstiffness self.Rstiffness];

% Beam Strand7 property identifier
propNum = self.propNum;

% set material data for Strand7 beam property
iErr = calllib('St7API','St7SetConnectionData',uID,propNum,...
    stiffness);
HandleError(iErr)
	
	
end