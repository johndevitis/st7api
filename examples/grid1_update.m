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

%% Import experimental data
efreq = [2.1 3.2 3.5 5.5];
%% setup st7 file info
sys = st7model();
sys.pathname = 'C:\Users\John\Projects_Git\st7api\models';
sys.filename = 'grid1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa info
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 4; % set number of modes to compute
nfa.run = 1;

%% setup updating parameters

modelPara = {};                
% Composite Action
CA = parameter();
CA.name = 'Xstif';
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

% % Girder Moment of Inertia
% gI = paramter();
% gI.obj = beam();
% gI.propNum = 1;
% lb = 0.8; ub = 1.5;
% 
% % Non-structural nodal mass
% NSM = node();
% NSM.id = [];
% lb = 0; ub = 500;
% 
% % Rotational springs at boundary conditions about y-axis
% BC = spring();
% BC.nodeid = [];
% lb = 1e5; ub = 1e11;
% 
% % Diaphragm  stiffness
% dia = beam();
% dia.propNum = 2;
% lb = 0.5; ub = 2;


%% Combine parameters
% assemble parameter start points and bounds
run = optimize();
run.modelPara = modelPara;
run.sys = sys;
run.solver = nfa;
run.assemblePara();
% Create randomn starting points for parameters
run.start = (run.ub-run.lb)*rand(length(run.ub),1)+run.lb;

%% set algoritm options
run.algorithm = 'PSO';
run.algOpt = PSOSET('SWARM_SIZE', 10  , ...
                 'MAX_ITER'  , 10  , ...
                 'TOLFUN'    , 1e-6 , ...
                 'TOLX'      , 1e-6 , ...
                 'DISPLAY'   , 'iter');


% anonymous objective function to be minimized
% create anonymous function that generates the data (residuals) to minimize
obj = @(para)grid1_obj(para,run,efreq);


[para,fval,exitflag,output] = PSO(obj,run.start,run.lb,run.ub,run.algOpt);


%% save model with different name
