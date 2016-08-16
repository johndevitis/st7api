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
% nfa.coords [x,y] is an optional input - nfa will snap or default to
% all nodes

nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 4; % set number of modes to compute
nfa.run = 1;


%% setup node restraints

% fully fixed
bc.ind = [1 11];
bc.restraint = ones(length(bc.ind),6);
bc.fcase = ones(size(bc.ind));


%% setup api run

% add discrete springs
% set node stiffness for model run 1
% Kt = zeros(11,3);           % [nodeInd(ii) x 3] translational stiffness
% Kr = zeros(11,3);           % [nodeInd(ii) x 3] rotational stiffness
% Kfc = 

springs = spring();
springs.Kt = [50 0 25; 50 0 25];
springs.Kr = [0 1 0; 0 1 0];
springs.Kfc = ones(size(springs.Kt,1),1);   
springs.id = [1 11];

% fully fixed
bc.ind = [1 11];
bc.restraint = ones(length(bc.ind),6);
bc.fcase = ones(size(bc.ind));

%% assign input structures to main model structure

model.sys = sys;
model.nfa = nfa;
model.bc = bc;
% model.beam = beam;
% model.springs = springs;


%% run the shell
% pass apish.m the function handle of your script and the structure you just 
% created. 
% 
% * apish(ell) wraps the function you pass to it in a try/catch
% statement for error handling and automated shutdown on error. it also
% handles api initialization
% create function handle 

fcn = @main;
results = apish(fcn,model);


%% plot displaced shapes

% dof = results.dof;
% 
% fh = figure('PaperPositionMode','auto');
% ah = axes();
% 
% % nfa - mode shape vector
% nfa = results(1).nfa;
% 
% mode = 1;
% scale = 1;
% z = nfa.U(:,3,mode)*scale; 
% 
% 
% % plot undeformed shape
% plot(dof.coords(:,1),dof.coords(:,3),...
%     'Marker','.',...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColo','k');
% hold(ah,'all')
% % plot mode
% plot(dof.coords(:,1),z,...
%     'color','b',...
%     'Marker','o',...
%     'MarkerEdgeColor','b',...
%     'MarkerFaceColor','b');
% % plot boundaries
% scatter(dof.bcoords(:,1),dof.bcoords(:,2),...
%     'MarkerEdgeColor','m',...
%     'MarkerFaceColor','m');
% % format axes
% hold(ah,'off')
% xlabel(ah,'Beam Length [ft]');
% ylabel(ah,'Modal Amplitude');
% ylim(ah,[-1.5 1.5]);
% grid(ah,'on');
% grid(ah,'minor');


















