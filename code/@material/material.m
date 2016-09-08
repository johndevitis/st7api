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
        E
        poisson
        thermalexp
        damping
        dampR
        thermalcond
        heat
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
    function shearmod = get.shearmod(self)
        shearmod = self.E/(2*(1+self.poisson));
    end
	end

%% static methods
	methods (Static)
        
	end

%% protected methods
	methods (Access = protected)
	end

end
