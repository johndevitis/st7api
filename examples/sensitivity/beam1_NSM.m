%% Beam1 - sensitivity study
%
% * multiple runs
%
%
% jbb 09132016

%% setup st7 file info
pathname = 'C:\Users\John\Projects_Git\st7api\models';
filename = 'beam1.st7';
scratchpath = 'C:\Temp';

%% setup nfa info
nfa = NFA();
nfa.name = fullfile(pathname,[filename(1:end-4) '.NFA']);
nfa.nmodes = 4; % set number of modes to compute
nfa.NSMcase = 1;
nfa.run = 1;

%% setup node restraints
nodes = node();
% Identify nodes to which non-structural mass will be applied
nodes.id = [5 6 7];

%% setup non-structural mass sensitivity study
% create mass range from 5 to 500 with 10 increments. 
% note its a row vector
steps = 10;
massrange = linspace(5,500,steps)';

% build model array
for ii = 1:steps
    % the class st7model is not a handle subclass. it is just a value
    % class, like a hard-coded structure. because of this we can create
    % copies of it
    sys = st7model();
    sys.filename = filename;
    sys.pathname = pathname;
    sys.scratchpath = scratchpath;
    beam(ii).sys = sys;
    
    % create new instance of nfa class
    % * this is because nfa subclasses the handle class. handles are 
    % persistent. if you create a copy and change it, the original changes 
    % too. we we need to create a new instance. 
    beam(ii).nfa = NFA();
    beam(ii).nfa.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)), ...
        '_step',num2str(ii),'.NFA');
    beam(ii).nfa.nmodes = 4;
    beam(ii).nfa.run = 1;
    
    % Node properties
    % Create new instance of node class
    % Instance labeled as NSMass for functionality
    beam(ii).NSMass = node();
    beam(ii).NSMass.id = nodes.id;
    beam(ii).NSMass.Mns = massrange(ii);
end


%% run the shell
tic

results = apish(@main,beam);

toc

%% view nfa info

plotNSMassVsFreq(results)


