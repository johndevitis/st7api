function setPlateThickness(self, uID)
%% setPlateThickness
% 
% 
% 
% author: John Braley
% create date: 13-Sep-2016 17:24:39
	
% Handle zero entry
if nargin<2; uID = 1; end

% Thickness
Doubles = ...
        [self.t ... % membrane thickness
        self.t];    % bending thickness
	
% Beam Strand7 property identifier
propNum = self.propNum;

% set plate thickness for Strand7 plate property
iErr = calllib('St7API','St7SetPlateThickness',uID,propNum,...
    Doubles);
HandleError(iErr)	
	
	
end
