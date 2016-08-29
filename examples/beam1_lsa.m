%% Beam1 Simply Supported Linear Static Solver
%
% jdv 08232016

%% setup st7model class
sys = st7model();
sys.pathname = 'C:\Users\John\Documents\MATLAB\repos\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa solver info
% Note that nfa.coords [x,y] is an optional input - nfa will snap or 
% default to all nodes
lsa = LSA();
lsa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.LSA']);
lsa.run = 1;
lsa.inputid = 3; % point load at nodeid=3
lsa.inputcase = 1; % loadcase = 1
lsa.fcase = 1; % freedom case
lsa.force = [0 0 -1e3]; % -1kip load at dof3
lsa.outputid = 1:11; % output at all nodes
lsa.outputcase = ones(size(lsa.outputid));



%% setup node restraints
bc = boundaryNode();
bc.nodeid = [1 11]; % boundary nodes
bc.restraint = [1 1 1 0 0 0; 0 1 1 0 0 0]; % [nnodes x 6dof] - simple beam
bc.fcase = ones(size(bc.nodeid));          % [nnodes x 1] - assign to case1

%% assign input structures to main model structure
model.sys = sys;
model.lsa = lsa;
model.bc = bc;

%% run the apis-shell using main function
fcn = @main;
results = apish(fcn,model);

%% view frequencies
fprintf('The nodal displacements are: \n');
fprintf('\t\tDZ\n')
fprintf('\t%f\n',results.lsa.resp(:,3));
