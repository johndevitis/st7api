%% Beam1 - sensitivity study
%
% * multiple runs
% Changes density of plate material
%
% jbb 09142016

%% setup st7 file info
pathname = 'C:\Users\John\Projects_Git\st7api\models';
filename = 'plate1.st7';
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
plates = plate(); % create instance of plate class
plates.propNum = 1; % Identify plate property number
plates.density = 0.284; % Set base density

% create density range from 0.5 to 5 with 10 increments. 
% note its a row vector
steps = 10;
dalpha = linspace(.5,5,steps)';

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
    
    % Deck properties
    % Create new instance of plate class
    % Instance labeled as deck for functionality
    beam(ii).deck = plate();
    beam(ii).deck.density = plates.density*dalpha(ii);
    beam(ii).deck.propNum = 1;
    
end


%% run the shell
tic

results = apish(@main,beam);

toc

%% view nfa info
field = 'density';
plotDeckMaterialVsFreq(results,field)












