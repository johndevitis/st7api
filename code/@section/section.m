classdef section < handle
%% classdef section
% 
% 
% 
% author: John Braley
% create date: 13-Sep-2016 14:54:15

%% object properties
	properties
        A       % Section area
        I11     % Second moment of area about the principal 1 axis
        I22     % Second moment of area about the principal 2 axis
        J       % Torsion constant
        SL1     % Shear center offset in the principle 1 axis
        SL2     % Shear center offset in the principle 2 axis
        SA1     % Shear area in the princliple 1 axis
        SA2     % Shear area in the principle 2 axis
        XBAR    % Centroid offset in the principle 1 axis
        YBAR    % Centroid offset in the principle 2 axis
        ANGLE   % Principle axis angle
        int     % number of integration slices
    end

end
