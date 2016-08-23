classdef LSA < handle
%% classdef lsa
% 
% 
% 
% author: john devitis
% create date: 15-Aug-2016 19:25:27

%% object properties
	properties
        name % result file name
        inputid % nodeid to apply load
        inputcase % input loadcase id
        outputid % nodeid to return results
        outputcase % output loadcase id
        force % [nnodes x (x y z]] force
        moment % not working yet
        fcase
        resp % [outputid x 6] from St7GetNodeResult
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
		function self = LSA()
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
