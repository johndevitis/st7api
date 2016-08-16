classdef node < handle
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
        ind
        ucsid = 1 % default ucs index = 1 = Global XYZ
        ucsname
        units % [length force stress mass temperature energy]
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
%         [ucsid, ucsname] = getUCSinfo(uID,nodes);
%         [Kt,Kr,ucsid,ucsname] = getNodeK(uID,nodes,freedomCaseNum)
%         dof = getNodes(uID,zz)
%         setNodeK(uID,nodes,fcasenum,ucsid,Kt,Kr)
	end

%% protected methods
	methods (Access = protected)
	end

end
