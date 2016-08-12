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

%% setup nfa info
nfa.resultname = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 8; % set number of modes to compute
% nfa.coords = beam1.dof.coords(:,[1 3]);
nfa.run = 1;

%% add discrete springs

% set node stiffness

Kt = zeros(11,3);
Kr = zeros(11,3);
Kfc = ones(size(Kt,1),1);

Kt([1 11],:) = [50 0 25; 50 0 25];
Kr([1 11],:) = [0 1 0; 0 1 0];

beam.Kt = Kt;
beam.Kr = Kr;
beam.Kfc = Kfc;


%% run the shell

beam.sys = sys;
beam.nfa = nfa;
beam = apish(beam);


%% plot displaced shapes

dof = beam.dof;

fh = figure('PaperPositionMode','auto');
ah = axes();

% nfa - mode shape vector
nfa = beam.nfa;
mode = 5;
scale = 1;
z = nfa.U(:,3,mode)*scale; 


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

ylim(ah,[-1.5 1.5]);

grid(ah,'on');
grid(ah,'minor');


















