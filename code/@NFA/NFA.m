classdef NFA
%% classdef NFA
% 
% 
% 
% author: john devitis
% create date: 15-Aug-2016 18:58:33

%% object properties
	properties
        name
        nmodes
        run
        units
        U
        freq
        modal
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
		function self = NFA()
		end

	%% dependent methods

	end

%% static methods
	methods (Static)
        [U,freq,modalres] = runNFA(uID,rname,nmodes,ind)
	end

%% protected methods
	methods (Access = protected)
	end

end
