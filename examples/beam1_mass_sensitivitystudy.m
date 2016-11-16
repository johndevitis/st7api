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
NFAnmodes = 4; % set number of modes to compute

% Instantiate st7 model
sys = st7model();
sys.filename = filename;
sys.pathname = pathname;
sys.scratchpath = scratchpath;


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

% add beams to parameters
modelP = parameter();
modelP.obj = beams;
modelP.name = 'density';

% Populate empty parameter fields
% api options
APIop = apiOptions();
APIop.keepLoaded = 1;
APIop.keepOpen = 1;
% run shell
apish(@getModelProp,sys,modelP,APIop);

% build model array
for ii = 1:steps
    
    % create new instance of nfa class
    % * this is because nfa subclasses the handle class. handles are 
    % persistent. if you create a copy and change it, the original changes 
    % too. we we need to create a new instance. 
    nfa = NFA();
    nfa.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)), ...
        '_step',num2str(ii),'.NFA');
    nfa.nmodes = NFAnmodes;
    nfa.run = 1;
    
    % Beam properties
    % Create new instance of parameter class
    bm = parameter();
    bm.obj = beams.clone; % create clone of previously defined beam class
    bm.obj.density = modelP.obj.density*dalpha(ii); % overwrite with step value
    bm.name = 'density'; % must correspond to the property being altered
    
    % add sensitivity info to "model" structure
    model(ii).params = bm;
    model(ii).solvers = nfa;
    model(ii).options.populate = 0; % don't repopulate st7 property values
end


%% run the shell
APIop.keepOpen = 0;

tic
% Run sensitivity shell
apish(@sensitivity,sys,model,APIop);
toc

%% view nfa info
plotMaterialVsFreq(model)












