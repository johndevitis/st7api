classdef plate < handle
%% classdef plate
% 
% 
% 
% author: 
% create date: 15-Aug-2016 18:57:07

%% object properties
	properties
        t % thickness
        propNum % St7 property number
        plateID % St7 element ID
        density % Deck material density
        E       % Modulus of Elasticity (psi) 
        propName % St7 property name
        plane   % string describing the resident plane (e.g. 'XY')
        layer   % elevation coordinate of plate
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
		function self = plate()
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
