%% Beam1 - Example2
%
% * multiple runs
%
%
% jdv 08142016

%% setup st7 file info
sys.pathname = 'C:\Users\John\Documents\MATLAB\repos\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa info
nfa.resultname = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
nfa.nmodes = 8; % set number of modes to compute
% nfa.coords = beam1.dof.coords(:,[1 3]);
nfa.run = 1;

%% setup api run

% index and global xyz assignment
% [nodeInd, x, y, z]
tInd = [ 1 1 0 1; 11 1 0 1]; 
rInd = [ 1 0 1 0; 11 0 1 0];
    
% add discrete unit springs
% [x y z]
Kt = zeros(11,3);           % translation
Kr = zeros(11,3);           % rotation
Kfc = ones(size(Kt,1),1);   % freedom case for each assignment

% loop springs and assign
for ii = 1:size(tInd,1)
    Kt(tInd(ii,1),:) = tInd(ii,2:end);
    Kr(rInd(ii,1),:) = rInd(ii,2:end);
end

% create spring range from 10^2 to 10*12 with 10 increments. start at 5 for
% stability
% note its a row vector
steps = 10;
springrange = logspace(2,12,steps)';

% build model array
for ii = 1:steps
    beam(ii).sys = sys;
    beam(ii).nfa = nfa;
    beam(ii).nfa.resultname = strcat(nfa.resultname(1:end-4),...
        '_step',num2str(ii),'.NFA');
    
    springs.Kt = Kt*springrange(ii);
    springs.Kr = Kr*springrange(ii);
    springs.Kfc = Kfc; % default to freedom case 1
    beam(ii).springs = springs;
end


%% run the shell

results = apish(beam);


%% view nfa info

plotSpringsVsFreq(results)




%% plot displaced shapes

dof = results(1).dof;

fh = figure('PaperPositionMode','auto');
ah = axes();

% nfa - mode shape vector
nfa = results(1).nfa;

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


















