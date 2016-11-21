classdef node < st7prop
%% classdef nodes
% 
% 
% 
% author: john devitis
% create date: 15-Aug-2016 17:31:52

%% object properties
	properties
        nnodes
        coords
        totalXYZ
        bcoords
        id % St7 node ID number
        ucsid = 1 % default ucs index = 1 = Global XYZ
        ucsname
        units % [length force stress mass temperature energy]
        Mns % non-structural nodal mass
        
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
		function self = node()
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
