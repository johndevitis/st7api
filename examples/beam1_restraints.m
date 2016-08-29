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

%% view results
fprintf('Number of nodes: %i\n',results.nodes.nnodes);
fprintf('UCS Name: %s\n',results.nodes.ucsname{1});
fprintf('Coordinates [ft]:\n');
fprintf('\t%f %f %f\n',results.nodes.coords(:,1));