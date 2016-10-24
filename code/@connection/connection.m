classdef connection
%% classdef beam
% 
% 
% 
% author: john devitis
% create date: 15-Aug-2016 18:23:09

%% object properties
	properties
        propNum % St7 property number
        beamID % St7 element ID
        propName % St7 property name
        Tstiffness [0 0 1e9] % translational stiffness. 3 element array: 1,2,3 element axes
        Rstiffness = [0 0 0] % rotational stiffness. 3 element array: 4,5,6 element axes
	end

%% dependent properties
	properties (Dependent)
	end

%% private properties
	properties (Access = private)
	end

%% dynamic methods
	methods
	%% constructor
		function self = connection()
		end

	%% dependent methods

	end

%% static methods
	methods (Static)
	end

%% protected methods
	methods (Access = protected)
	end

end
