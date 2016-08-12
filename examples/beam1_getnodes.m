%% Beam1 - Sensitivity Study Example
%
%
% jdv 08122016

%% Setup 

% st7 file info
sys.pathname = 'C:\Users\John\Documents\MATLAB\repos\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:\Temp';

%% use the api shell to pull node info
beam1.sys = sys; 
beam1 = apish(beam1);

%% plot nodes
fh = figure;
ph(1) = plot(beam1.dof.coords(:,1),beam1.dof.coords(:,2),...
             'Marker','o',...
             'MarkerEdgeColor','b',...
             'MarkerFaceColo','b');
hold on
colr = 'r';
ph(2) = scatter(beam1.dof.bcoords(:,1),beam1.dof.bcoords(:,2),...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','k');
hold off