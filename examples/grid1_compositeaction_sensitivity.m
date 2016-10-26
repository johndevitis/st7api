%% Sensitivity study on grid1.st7 of composite action
% connection element stiffness to be altered
%
%           jbb - 10242016

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

%% Run Sensitivity studies on parameters.

%% Composite Action
% Alter section property of composite action connection element
ca = connection(); % create instance of connection class
ca.propNum = 3; % Identify beam property number
% Create stiffness range
steps = 12;
stif = logspace(4,12,steps)';

% build model array
for ii = 1:steps
    % the class st7model is not a handle subclass. it is just a value
    % class, like a hard-coded structure. because of this we can create
    % copies of it
    grid(ii).sys = sys;
    
    % create new instance of nfa class
    % * this is because nfa subclasses the handle class. handles are 
    % persistent. if you create a copy and change it, the original changes 
    % too. we we need to create a new instance. 
    grid(ii).nfa = NFA();
    grid(ii).nfa.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)), ...
        '_step',num2str(ii),'.NFA');
    grid(ii).nfa.nmodes = 10;
    grid(ii).nfa.run = 1;
    
    % Connection element properties
    % Create copy of connection instance
    % Instance labeled as comp for functionality
    grid(ii).comp = ca;
    grid(ii).comp.Tstiffness = [stif(ii) stif(ii) 1e9];
    
end

%% run the shell
tic

results = apish(@main,grid);

toc
% plot frequency vs. connection element stiffness
field = 'Tstiffness';
plotCompVsFreq(results,field);