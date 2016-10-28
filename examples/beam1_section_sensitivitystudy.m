%% Beam1 - sensitivity study
%
% * multiple runs
% Changes beam section - Ix
%
% jbb 09072016

%% setup st7 file info
pathname = 'C:\Users\John\Projects_Git\st7api\models';
filename = 'beam1.st7';
scratchpath = 'C:\Temp';

%% setup nfa info
nfa = NFA();
nfa.name = fullfile(pathname,[filename(1:end-4) '.NFA']);
nfa.nmodes = 4; % set number of modes to compute
nfa.run = 1;

%% setup beam section sensitivity study
% Alter section property of beam material
%
% *pay attention, this section is tricky*
beams = beam(); % create instance of beam class
beams.propNum = 1; % Identify beam property number

% create Ix range from 10 to 500 with 10 increments. 
% note its a row vector
steps = 10;
ixx = linspace(10,500,steps)';

% build model array
for ii = 1:steps
    % the class st7model is not a handle subclass. it is just a value
    % class, like a hard-coded structure. because of this we can create
    % copies of it
    sys = st7model();
    sys.filename = filename;
    sys.pathname = pathname;
    sys.scratchpath = scratchpath;
    cantilever(ii).sys = sys;
    
    % create new instance of nfa class
    % * this is because nfa subclasses the handle class. handles are 
    % persistent. if you create a copy and change it, the original changes 
    % too. we we need to create a new instance. 
    cantilever(ii).nfa = NFA();
    cantilever(ii).nfa.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)), ...
        '_step',num2str(ii),'.NFA');
    cantilever(ii).nfa.nmodes = 4;
    cantilever(ii).nfa.run = 1;
    
    % Beam properties
    % Create new instance of beam class
    % Instance labeled as materials for functionality
    cantilever(ii).sections = beam();
    cantilever(ii).sections.I11 = ixx(ii);
    cantilever(ii).sections.propNum = 1;
    
end


%% run the shell
tic

results = apish(@main,cantilever);

toc

%% view nfa info
field = 'I11';
plotSectionVsFreq(results,field)












