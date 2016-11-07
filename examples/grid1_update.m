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

%% Import experimental data
efreq = [1.86 3.45 6.868 8.811 10.4];
% read in dof locations
edof = dof();
edof.read('dof-grid1.csv','delimiter',',');

%% setup st7 file info
sys = st7model();
sys.pathname = 'C:\Users\John\Projects_Git\st7api\models';
sys.filename = 'grid1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa info
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 5; % set number of modes to compute
nfa.run = 1;

%% setup updating parameters

modelPara = {};                
% Composite Action
CA = parameter();
CA.name = 'Xstif'; % name parameter consistant with object property
CA.obj = connection();
CA.obj.propNum = 3;
CA.lb = 1e4;
CA.ub = 1e12;
modelPara{end+1} = CA;

% Deck Stiffness
DE = parameter();
DE.name = 'E';
DE.obj = plate();
DE.obj.propNum = 1;
DE.lb = 57000*sqrt(1500); DE.ub = 57000*sqrt(10000);
modelPara{end+1} = DE;

% Girder Moment of Inertia
gI = parameter();
gI.obj = beam();
gI.name = 'I11';
gI.obj.propNum = 1;
gI.lb = 0.8*292.3958333333; gI.ub = 1.5*292.3958333333;
modelPara{end+1} = gI;

% Non-structural nodal mass
NSM = parameter();
NSM.obj = node();
NSM.obj.id = [364 421];
NSM.name = 'Mns'; 
NSM.lb = 0; NSM.ub = 500;
modelPara{end+1} = NSM;

% Rotational springs at boundary conditions about y-axis
BC = parameter();
BC.obj = spring();
BC.obj.nodeid = [855 856 857 7 8 9];
BC.name = 'KrY';
BC.obj.Kfc = 1;
BC.lb = 1e5; BC.ub = 1e11;
modelPara{end+1} = BC;

% Diaphragm  stiffness
dia = parameter();
dia.obj = beam();
dia.obj.propNum = 2;
dia.name = 'E';
dia.lb = 0.5*29e6; dia.ub = 2*29e6;
modelPara{end+1} = dia;


%% Combine parameters
% assemble parameter start points and bounds
run = optimize();
run.modelPara = modelPara;
run.sys = sys;
run.solver = nfa;
run.assemblePara();
% Create randomn starting points for parameters
run.start = (run.ub-run.lb).*rand(1,length(run.ub))+run.lb;


%% Import experimental data
run.edata.efreq = efreq;
run.edata.dof = edof;

%% Get model nodeID numbers that match experimental output DOF
% api options
APIop = apiOptions();
APIop.keepLoaded = 1;
APIop.keepOpen = 1;

% Pull all model nodes and match with DOF locations
run.edata.nodes = apish(@findNodes,run,APIop);

% Initialize analytical data
run.adata = {};

%% set algoritm options
run.algorithm = 'PSO';
run.algOpt = PSOSET('SWARM_SIZE', 10  , ...
                 'MAX_ITER'  , 10  , ...
                 'TOLFUN'    , 1e-6 , ...
                 'TOLX'      , 1e-6 , ...
                 'DISPLAY'   , 'iter');


% anonymous objective function to be minimized
% create anonymous function that generates the data (residuals) to minimize
obj = @(para)grid1_obj(para,run,run.edata);


[para,fval,exitflag,output] = PSO(obj,run.start,run.lb,run.ub,run.algOpt);

%% apply final parameters and save model with different name
out = obj(para);
new_filename = [run.sys.filename(1:end-4) '_' Name '.st7'];
api.saveas(run.sys.uID,sys.pathname,new_filename);

%% Close Model
api.closeModel(run.sys.uID)
run.sys.open=0;

%% results and model parameter values for each iteration and resulting frequencies
% can be found in run.adata