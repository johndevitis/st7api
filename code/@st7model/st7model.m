classdef st7model < handle
%% classdef st7model
% 
% 
% 
% author: john devitis
% create date: 15-Aug-2016 19:30:12

%% object properties
	properties
        pathname
        filename
        scratchpath
        open = 0; % boolean indicating if the model file is already open
        uID = 1 % file identifier for api commands
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
		function self = st7model()
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
