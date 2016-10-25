%% Sensitivity study on grid1.st7 of rotational springs at boundaries
% 
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

%% setup spring sensitivity study
% Create rotational springs about the x-axis for boundary nodes
springs = spring();
springs.nodeid = [7 8 9 855 856 857]; 
% create unit spring force at desired dof
Kr = [0 1 0];

% create spring range from 10^5 to 10*15 with 10 increments. 
% note its a row vector
steps = 10;
springrange = logspace(5,15,steps)';

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
    grid(ii).nfa.nmodes = 5;
    grid(ii).nfa.run = 1;
    
    % springs
    % this class is also *not* a subclass of handles. we can use copies. 
    % note that a row of rotational stiffness values is defined for each
    % nodeid. In this case they are all the same, but could be defined
    % separately
    springs.Kr = padarray(Kr*springrange(ii),length(springs.nodeid)-1,'replicate','post');
    springs.Kfc = ones(size(springs.Kr,1),1); % default to freedom case 1
    grid(ii).springs = springs;
    
end

%% run the shell
tic

results = apish(@main,grid);

toc


%% view nfa info

plotSpringsVsFreq(results)