classdef parameter < handle
%% classdef parameter
% 
% 
% 
% author: John Braley
% create date: 26-Oct-2016 14:36:55

%% object properties
	properties
        name % name of parameter
        ub % upper bound for optimization
        lb % lower bound for optimization
        start % starting point for optimization
        obj % instance of class containing all model info for parameter
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
		function self = parameter()
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
