classdef optimize
%% classdef update
% 
% for the purpose of FE model updating
% 
% author: John Braley
% create date: 25-Oct-2016 17:07:08

%% object properties
	properties
        parameters % model parameters to be adjusted during updating
        ub  % corresponding upper bound for parameters
        lb % lower bounds for parameters
        start % starting point of parameters for updating run
        paraind % index of parameters (for start and bounds)
        algorithm % name of updating algorithm
        options % algorithm options
        edata % experimental data set (to be compared with analytical data -- model results)       
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
		function self = update()
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
