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
        Kt % [1 x 3] translational stiffness
        Kr % [1 x 3] rotational stiffness
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
        KtX = self.KtX;
        KtY = self.KtY;
        KtZ = self.KtZ;
        if isempty(KtX)
            KtX = 0;
        end
        if isempty(KtY)
            KtY = 0;
        end
        if isempty(KtZ)
            KtZ = 0;
        end
        Kt = cat(2, KtX, KtY, KtZ);
        if all(~Kt)
            Kt = [];
        end
    end
    function Kr = get.Kr(self)
        KrX = self.KrX;
        KrY = self.KrY;
        KrZ = self.KrZ;
        if isempty(KrX)
            KrX = 0;
        end
        if isempty(KrY)
            KrY = 0;
        end
        if isempty(KrZ)
            KrZ = 0;
        end
        Kr = cat(2, KrX, KrY, KrZ);
        if all(~Kr)
            Kr = [];
        end
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
