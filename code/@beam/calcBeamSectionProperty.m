function calcBeamSectionProperty(uID,propNum,shear,exactJ)
%% calcBeamSectionProperty
% 
% From Strand7 API Manual:
% 
% shear - Include the shear area values, either 0 (false, default) or 1
% (true). If the shear areas are included the “thick” beam formulation is 
% used.
% 
% exactJ - Perform an accurate calculation for the torsional constant, 
% either 0 (false, default), or 1 (true). If this flag is set to false a
% fast but approximate calculation is performed.
%
% author: john devitis
% create date: 15-Aug-2016 12:26:41

global btTrue btFalse
    % check optional inputs
    % default to false for each
    if nargin < 3; shear = 0; end;
    if nargin < 4; exactJ = 0; end;
	
	% calculate section properties
    if shear && exactJ
        [iErr,propNum] = calllib('St7API','St7CalculateBeamSectionProperties',...
            uID,propNum,btTrue,btTrue);
        HandleError(iErr);
    elseif shear && ~exactJ
        [iErr,propNum] = calllib('St7API','St7CalculateBeamSectionProperties',...
            uID,propNum,btTrue,btFalse);
        HandleError(iErr);
    elseif ~shear && exactJ
        [iErr,propNum] = calllib('St7API','St7CalculateBeamSectionProperties',...
            uID,propNum,btFalse,btTrue);
        HandleError(iErr);
    elseif ~shear && ~exactJ
        [iErr,propNum] = calllib('St7API','St7CalculateBeamSectionProperties',...
            uID,propNum,btFalse,btFalse);
        HandleError(iErr); 
    end
end
