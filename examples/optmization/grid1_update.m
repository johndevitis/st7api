%% Update grid1.st7 model using natural frequency data
%
%
%           jbb - 10242016
%% Parameters to be updated - with bounds as established by sensitivity studies:
% ca - composite action connection element stiffness [1e4 - 1e12] 
% dE - deck stiffness (E) fc = [1500 10000] -> E = [2.2e6 5.7e6] 
% gI - girder Ix (I11) - [.8X 1.5X]
% NSM - nodal mass at deck edges (to simulate barrier) - [0 1500]
% boundary conditions (rotational stiffness) - [1e5 1e11]
% dia - Diaphragm stiffness (E) - [0.5X - 2X]

%% Name of update run
Name = 'update_1';

%% Import vma libraries
pname{1} = 'C:\Users\John\Projects_Git\vma';
pname{2} = 'C:\Users\John\Projects_Git\classio';
for ii = 1:length(pname)
    addpath(genpath(pname{ii}));
end

%% setup st7 file info
sys = st7model();
sys.pathname = 'C:\Users\John\Projects_Git\st7api\models';
sys.filename = 'grid1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa info
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 9; % set number of modes to compute
nfa.run = 1;

%% setup updating parameters
modelPara = {};    


% % Composite Action
% CA = parameter();
% CA.name = 'Xstif'; % name parameter consistant with object property
% CA.obj = connection();
% CA.obj.propNum = 3;
% % CA.base = 1;
% CA.scale = 'log';
% CA.lba = 4;
% CA.uba = 12;
% modelPara{end+1} = CA;

% Deck Stiffness
DE = parameter();
DE.name = 'E';
DE.obj = plate();
DE.obj.propNum = 1;
DE.scale = 'lin';
DE.lba = .5; DE.uba = 2;
modelPara{end+1} = DE;

% Girder Moment of Inertia
gI = parameter();
gI.obj = beam();
gI.name = 'I11';
gI.obj.propNum = 1;
gi.scale = 'lin';
gI.lba = 0.8; gI.uba = 1.5;
modelPara{end+1} = gI;
% 
% % Non-structural nodal mass
% NSM = parameter();
% NSM.obj = node();
% NSM.obj.id = [364 421];
% NSM.name = 'Mns'; 
% NSM.base = 500;
% NSM.scale = 'lin';
% NSM.lba = 0; NSM.uba = 1;
% modelPara{end+1} = NSM;
% 
% Rotational springs at boundary conditions about y-axis
BC = parameter();
BC.obj = spring();
BC.obj.nodeid = [855 856 857 7 8 9];
BC.name = 'KrY';
BC.obj.Kfc = 1;
BC.base = 1;
BC.scale = 'log';
BC.lba = 5; BC.uba = 11;
modelPara{end+1} = BC;

% % Diaphragm  stiffness
% dia = parameter();
% dia.obj = beam();
% dia.obj.propNum = 2;
% dia.name = 'E';
% dia.scale = 'lin';
% dia.lba = 0.5; dia.uba = 2;
% modelPara{end+1} = dia;


%% Combine parameters
% assemble parameter start points and bounds
run = optimize();
run.modelPara = modelPara;
run.sys = sys;
run.solver = nfa;
run.assemblePara();
% Create randomn starting points for parameters
run.start = (run.ub-run.lb).*rand(1,length(run.ub))+run.lb;

%% Pull existing property values from model and populate any empty parameter "base" values 
setParaBase(sys,run.modelPara);

%% Import experimental data
% read in dof locations
edof = node();
etab = readtable('dof-grid1.csv');
edof.coords(:,1) = etab.x;
edof.coords(:,2) = etab.y;
edof.coords(:,3) = etab.z;
edata.nodes = edof;

% Get model nodeID numbers that match experimental output DOF
% api options
APIop = apiOptions();
APIop.keepLoaded = 1;
APIop.keepOpen = 0;

% Pull all model nodes and match with DOF locations
run.edata = edata;
apish(@findNodes,sys,edata.dof,APIop);

% Run nfa on reference model
ref = st7model();
ref.pathname = 'C:\Users\John\Projects_Git\st7api\models';
ref.filename = 'grid1_mod.st7';
ref.scratchpath = 'C:\Temp';
ref.uID = 2;
init = optimize();
init.sys = ref;
init.solver = nfa;
init.edata = edata;
results = apish(@update,init,APIop);
% assign nfa results to edata
edata.freq = init.solver.freq;
edata.U = init.solver.U;
run.edata = edata;

%% Under construction...
% Re-sample experimental dofs from model
% reassine to edata.U

%% Run Optimization Algorithm
% Initialize analytical data
run.adata = {};
% reset number of modes to solve for
run.solver.nmodes = 15;
APIop.keepOpen = 1;
% anonymous objective function to be minimized
% create anonymous function that generates the data (residuals) to minimize
obj = @(para)grid1_obj(para,run,run.edata);

%% Specific algorithm implementation
% Particle Swarm
% set algoritm options for particle swarm
% run.algorithm = 'particleswarm';
% run.algOpt = optimoptions('particleswarm',...
%                             'SwarmSize',20,...
%                             'HybridFcn',@fmincon,...
%                             'MaxIterations', 20);
% 
% [para,fval,exitflag,output] = particleswarm(obj,run.start,run.lb,run.ub,run.algOpt);

%% gradient based
run.algorithm = 'lsqnonlin';
run.algOpt = optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective',...
                'TolFun',1e-6,...
                'TolX',1e-4,...
                'Display','iter');
[x,resnorm,residual,exitflag,output] = lsqnonlin(obj,run.start,run.lb,run.ub,run.algOpt);

%% apply final parameters and save model with different name
% out = obj(x);
new_filename = [run.sys.filename(1:end-4) '_' Name '.st7'];
api.saveas(sys.uID,sys.pathname,new_filename);

%% Close Model
api.closeModel(run.sys.uID)
run.sys.open=0;

%% results and model parameter values for each iteration and resulting frequencies
% can be found in run.solver