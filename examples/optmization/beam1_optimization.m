%% Beam1 - update with dynamic info
%
% Structure:
%   simply supported beam with rotational spring at pinned end. 
%   spring value is randomly created within the sensitive range (determined
%   in beam1_sensitivity example)
%
% Experiment: 
%   the 'experimental' data is the first three modes of the beam
%
% 
% jdv 08182016

%% Setup structure and get "experimental" data from random spring value

% setup st7 file info
sys = st7model();
sys.pathname = 'C:\Users\John\Documents\MATLAB\repos\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:\Temp';
% setup nfa info
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 3; 
nfa.run = 1;
% setup node restraints
bc = boundaryNode();
bc.nodeid = [1 11];
bc.restraint = zeros(length(bc.nodeid),6); % no restraints
bc.restraint(1,1:3) = 1; % pinned
bc.restraint(11,2:3) = 1; % roller (x kept released)
bc.fcase = ones(size(bc.nodeid));

% spring value:
%  generate a random number between 1e7 and 1e11
lb = 1e5; ub = 1e9;
k = (ub-lb)*rand(1,1)+lb;
springs = spring();
springs.nodeid = 1;
springs.Kr = [0 k 0];  %assign spring value
springs.Kfc = 1;

% assign to beam struct and call api
beam.sys = sys;
beam.nfa = nfa;
beam.bc = bc;
beam.springs = springs;
results = apish(@main,beam);

efreq = results.nfa.freq;

%% setup optimization

tic

% use random starting guess
lb = 1e7; 
ub = 1e11;
initpara = (ub-lb)*rand(1,1)+lb;


options = PSOSET('SWARM_SIZE', 10  , ...
                 'MAX_ITER'  , 10  , ...
                 'TOLFUN'    , 1e-6 , ...
                 'TOLX'      , 1e-6 , ...
                 'DISPLAY'   , 'iter');

% create anonymous function that generates the data (residuals) to minimize
% * re-use the beam structure for api calls
obj = @(para)beam1_obj(para,beam,efreq);

[para,fval,exitflag,output] = PSO(obj,initpara,lb,ub,options);


toc

























