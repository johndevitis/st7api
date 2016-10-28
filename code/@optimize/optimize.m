classdef optimize < handle
%% classdef update
% 
% for the purpose of FE model updating
% 
% author: John Braley
% create date: 25-Oct-2016 17:07:08

%% object properties
	properties
        modelPara % model parameters to be adjusted during updating
        ub  % corresponding upper bound for parameters
        lb % lower bounds for parameters
        start % starting point of parameters for updating run
        paraind % index of parameters (for start and bounds)
        algorithm % name of updating algorithm
        solver % solver object
        sys % St7 model object with file info
        algOpt % algorithm options
        edata % experimental data set (to be compared with analytical data -- model results)       
        adata % analytical data, saved during run
	end

%% dependent properties
	properties (Dependent)
        numPara
	end

%% private properties
	properties (Access = private)
	end

%% dynamic methods
	methods
	%% constructor
		function self = optimize()
		end

	%% dependent methods
    function numPara = get.numPara(self)
        numPara = length(self.modelPara);
    end

	end

%% static methods
	methods (Static)
	end

%% protected methods
	methods (Access = protected)
	end

end
