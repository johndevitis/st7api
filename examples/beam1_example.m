%% Beam1 - Example
%
% 
%
%
% jdv 08122016

%% setup st7 file info
sys.pathname = 'C:\Users\John\Documents\MATLAB\repos\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:\Temp';
beam1.sys = sys;

%% setup nfa info
nfa.resultname = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 5; % set number of modes to compute
nfa.coords = beam1.dof.coords(:,[1 3]);
beam1.nfa = nfa;

%% use the api shell to pull node info
beam1 = apish(beam1);

%% plot mode shapes

fh = figure('PaperPositionMode','auto');
ah = axes();

mode = 5;
scale = 1;

dof = beam1.dof;
nfa = beam1.nfa;

z = nfa.U(:,3,mode)*scale; % mode shape

% plot undeformed shape
plot(dof.coords(:,1),dof.coords(:,3),...
    'Marker','.',...
    'MarkerEdgeColor','k',...
    'MarkerFaceColo','k');

hold(ah,'all')
            
% plot mode
plot(dof.coords(:,1),z,...
    'color','b',...
    'Marker','o',...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor','b');

% plot boundaries
scatter(dof.bcoords(:,1),dof.bcoords(:,2),...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m');

            
hold(ah,'off')

xlabel(ah,'Beam Length [ft]');
ylabel(ah,'Modal Amplitude');


% ylim(ah,[-1.5 1.5]*max(abs(scale*z)));
ylim(ah,[-1.5 1.5]);

grid(ah,'on');
grid(ah,'minor');


















