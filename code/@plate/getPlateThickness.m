function thick = getPlateThickness(self,uID)
%% getPlateThickness
% 
% 
% 
% author: John Braley
% create date: 09-Nov-2016 12:44:09
	
% Handle zero entry
if nargin<2; uID = 1; end

% Intitialize st7 output
Thickness = zeros(1,2);
	
% Beam Strand7 property identifier
propNum = self.propNum;

% get plate thickness for FIRST Strand7 plate property
[iErr, Thickness] = calllib('St7API','St7GetPlateThickness',uID,propNum(1),...
    Thickness);
HandleError(iErr)		

% write to output variable
thick.t = Thickness(1);
	
	
end
