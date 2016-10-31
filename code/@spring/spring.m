classdef spring < handle
%% classdef spring
% 
% 
% 
% author: john devitis
% create date: 16-Aug-2016 11:38:45

%% object properties
	properties
        KtX
        KtY
        KtZ
        KrX
        KrY
        KrZ
        Kfc % freedom case to be applied
        nodeid % node index
	end

%% dependent properties
	properties (Dependent)
        Kt % [nodeInd(ii) x 3] translational stiffness
        Kr % [nodeInd(ii) x 3] rotational stiffness
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
    function Kt = get.Kt(self)
        Kt = cat(2, self.KtX, self.KtY, self.KtZ);
    end
    function Kr = get.Kr(self)
        Kr = cat(2, self.KrX, self.KrY, self.KrZ);
    end
    function set.Kt(self,value)
        if length(value) == 3
            self.KtX = value(1);
            self.KtY = value(2);
            self.KtZ = value(3);
        end
    end
    function set.Kr(self,value)
        if length(value) == 3
            self.KrX = value(1);
            self.KrY = value(2);
            self.KrZ = value(3);
        end
    end

	end

%% static methods
	methods (Static)
	end

%% protected methods
	methods (Access = protected)
	end

end
