%% Beam1 - Example1
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
nfa.run = 1;

%% setup api run

% add discrete springs
% set node stiffness for model run 1
Kt = zeros(11,3);           % translation
Kr = zeros(11,3);           % rotation
Kfc = ones(size(Kt,1),1);   % freedom case for each assignment

Kt([1 11],:) = [50 0 25; 50 0 25];
Kr([1 11],:) = [0 1 0; 0 1 0];

springs.Kt = Kt;
springs.Kr = Kr;
springs.Kfc = Kfc;

beam.sys = sys;
beam.nfa = nfa;
beam.springs = springs;

%% run the shell

results = apish(beam);


%% plot displaced shapes

dof = results.dof;

fh = figure('PaperPositionMode','auto');
ah = axes();

% nfa - mode shape vector
nfa = results(1).nfa;

mode = 1;
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


















