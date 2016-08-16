classdef spring 
%% classdef spring
% 
% 
% 
% author: john devitis
% create date: 16-Aug-2016 11:38:45

%% object properties
	properties
        Kt % [nodeInd(ii) x 3] translational stiffness
        Kr % [nodeInd(ii) x 3] rotational stiffness
        Kfc % freedom case to be applied
        ind % node index
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
		function self = spring()
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
