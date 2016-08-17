%% Beam1 - Assign Boundary Conditions (node restraints) and get node info
%
% jdv 08172016

%% setup st7model class
sys = st7model();
sys.pathname = 'C:\Users\John\Documents\MATLAB\repos\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:\Temp';

%% setup node restraints
bc = boundaryNode();
bc.nodeid = [1 11]; % fully fixed at nodes 1 and 11
bc.restraint = ones(length(bc.nodeid),6); % [nnodes x 6dof]
bc.fcase = ones(size(bc.nodeid));         % [nnodes x 1]

%% assign input structures to main model structure
model.sys = sys;
model.bc = bc;

%% run the apis-shell using main function
fcn = @main;
results = apish(fcn,model);