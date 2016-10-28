%% Beam1 - sensitivity study
%
% * multiple runs
% Changes density of material
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

% %% setup node restraints
% bc = boundaryNode();
% bc.nodeid = [1 11];
% bc.restraint = zeros(length(bc.nodeid),6); % no restraints
% bc.restraint(1,1:3) = 1; % pinned
% bc.restraint(11,2:3) = 1; % roller (x kept released)
% bc.fcase = ones(size(bc.nodeid));

%% setup material density sensitivity study
% Alter density of beam material
%
% *pay attention, this section is tricky*
beams = beam(); % create instance of beam class
beams.propNum = 1; % Identify beam property number
beams.density = 0.284; % Set base density

% create density range from 0.5 to 5 with 10 increments. 
% note its a row vector
steps = 10;
dalpha = linspace(.5,5,steps)';

% build model array
for ii = 1:steps
    % the class st7model is a handle subclass. 
    % Create new instance of St7model class
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
    cantilever(ii).materials = beam();
    cantilever(ii).materials.density = beams.density*dalpha(ii);
    cantilever(ii).materials.propNum = 1;
    
end


%% run the shell
tic

results = apish(@main,cantilever);

toc

%% view nfa info
field = 'density';
plotMaterialVsFreq(results,field)












