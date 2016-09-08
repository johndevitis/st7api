classdef material < handle
%% classdef material
% 
% 
% 
% author: John Braley
% create date: 29-Aug-2016 15:44:09

%% object properties
	properties
        name
        density
        modulus
        
        poisson
        thermal
	end

%% dependent properties
	properties (Dependent)
        shearmod
	end

%% private properties
	properties (Access = private)
	end

%% dynamic methods
	methods
	%% constructor
		function self = material()
		end

	%% dependent methods
    function get.shearmod
    end
	end

%% static methods
	methods (Static)
        
	end

%% protected methods
	methods (Access = protected)
	end

end
