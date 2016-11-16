classdef st7prop < handle
%% classdef st7prop
% 
% 
% 
% author: John Braley
% create date: 15-Nov-2016 17:09:13

%% object properties
	properties
        
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
		function self = st7prop()
        end
        
        % make a clone of instance
        function new = clone(self)
            new = feval(class(self));
            
            p = properties(self);
            info = metaclass(self);
            
            for ii = 1:length(p)
                if ~info.PropertyList(ii).Dependent
                    new.(p{ii}) = self.(p{ii});
                end
            end
        end

	%% ordinary methods

	%% dependent methods

	end

%% static methods
	methods (Static)
	end

%% protected methods
	methods (Access = protected)
	end

end
