%% Beam1 - Example1
%
% 
%
%
% jdv 08122016

%% setup st7 file info
sys = st7model();
sys.pathname = 'C:\Users\John\Documents\MATLAB\repos\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa solver info
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 4; % set number of modes to compute
nfa.run = 1;

%% setup node restraints
bc = boundaryNode();
bc.nodeid = [1 11];
bc.restraint = zeros(length(bc.nodeid),6); % no restraints
bc.fcase = ones(size(bc.nodeid));

%% setup api run
% Add discrete longitudinal (x) and vertical (z) translational springs.
% No rotational springs added
springs = spring();
springs.Kt = [1e5 0 1e5; 1e5 0 1e5];
springs.Kr = [0 1 0; 0 1 0];
springs.Kfc = ones(size(springs.Kt,1),1);   
springs.nodeid = [1 11];

%% assign input structures to main model structure
model.sys = sys;
model.nfa = nfa;
model.bc = bc;
model.springs = springs;

%% run the shell
fcn = @main;
results = apish(fcn,model);

%% view frequencies
fprintf('Natural Frequencies [Hz]:\n');
fprintf('%f\n',results.nfa.freq);


















