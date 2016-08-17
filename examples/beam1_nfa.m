%% Beam1 Fixed-Fixed NFA example
%
% jdv 08172016

%% setup st7model class
sys = st7model();
sys.pathname = 'C:\Users\John\Projects_Git\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa solver info
% Note that nfa.coords [x,y] is an optional input - nfa will snap or 
% default to all nodes
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 4; % set number of modes to compute
nfa.run = 1;

%% setup node restraints
bc = boundaryNode();
bc.nodeid = [1 11]; % fully fixed at nodes 1 and 11
bc.restraint = ones(length(bc.nodeid),6); % [nnodes x 6dof]
bc.fcase = ones(size(bc.nodeid));         % [nnodes x 1]

%% assign input structures to main model structure
model.sys = sys;
model.nfa = nfa;
model.bc = bc;

%% run the apis-shell using main function
fcn = @main;
results = apish(fcn,model);

%% view frequencies
fprintf('Natural Frequencies [Hz]:\n');
fprintf('%f\n',results.nfa.freq);
% 
% % plot displaced shapes
% 
% nodes = results.nodes;
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
% plot(nodes.coords(:,1),nodes.coords(:,3),...
%     'Marker','.',...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColo','k');
% hold(ah,'all')
% % plot mode
% plot(nodes.coords(:,1),z,...
%     'color','b',...
%     'Marker','o',...
%     'MarkerEdgeColor','b',...
%     'MarkerFaceColor','b');
% % plot boundaries
% scatter(nodes.bcoords(:,1),nodes.bcoords(:,2),...
%     'MarkerEdgeColor','m',...
%     'MarkerFaceColor','m');
% % format axes
% hold(ah,'off')
% xlabel(ah,'Beam Length [ft]');
% ylabel(ah,'Modal Amplitude');
% ylim(ah,[-1.5 1.5]);
% grid(ah,'on');
% grid(ah,'minor');