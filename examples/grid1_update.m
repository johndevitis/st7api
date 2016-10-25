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


%% setup st7 file info
sys = st7model();
sys.pathname = 'C:\Users\John\Projects_Git\st7api\models';
sys.filename = 'grid1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa info
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 12; % set number of modes to compute
nfa.run = 1;

%% Run Sensitivity studies on parameters.


%% run the shell
tic

results = apish(@main,grid);

toc
% plot frequency vs. connection element stiffness
field = 'Tstiffness';
plotCompVsFreq(results,field);