%% Beam1 - sensitivity study
%
% * multiple runs
% Changes density of material
%
% jbb 09072016

%% setup st7 file info
sys = st7model();
sys.pathname = 'C:\Users\John\Projects_Git\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:\Temp';

%% setup nfa info
nfa = NFA();
nfa.name = fullfile(sys.pathname,[sys.filename(1:end-4) '.NFA']);
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
beams = beam(); % create instance of beam class
beams.propNum = 1; % Identify beam property number
beams.density = 0.284; % Set base density

% create density range from 0.5 to 5 with 10 increments. 
% note its a row vector
steps = 10;
dalpha = linspace(.5,5,steps)';

% build model array
for ii = 1:steps
    % the class st7model is not a handle subclass. it is just a value
    % class, like a hard-coded structure. because of this we can create
    % copies of it
    cantilever(ii).sys = sys;
    
    % create new instance of nfa class
    % * this is because nfa subclasses the handle class. handles are 
    % persistent. if you create a copy and change it, the original changes 
    % too. we we need to create a new instance. 
    cantilever(ii).nfa = NFA();
    cantilever(ii).nfa.name = strcat(fullfile(sys.pathname,sys.filename(1:end-4)), ...
        '_step',num2str(ii),'.NFA');
    cantilever(ii).nfa.nmodes = 4;
    cantilever(ii).nfa.run = 1;
    
    % Beam properties
    % Create new instance of beam class
    % Instance labeled as materials for functionality
    cantilever(ii).materials = beam();
    cantilever(ii).materials.density = beams.density*dalpha(ii);
    cantilever(ii).materials.propNum = 1;
    
end


%% run the shell
tic

results = apish(@main,cantilever);

toc

%% view nfa info

plotSpringsVsFreq(results)




% %% plot displaced shapes
% 
% dof = results(1).dof;
% 
% fh = figure('PaperPositionMode','auto');
% ah = axes();
% 
% % nfa - mode shape vector
% nfa = results(1).nfa;
% 
% mode = 5;
% scale = 1;
% z = nfa.U(:,3,mode)*scale; 
% 
% 
% % plot undeformed shape
% plot(dof.coords(:,1),dof.coords(:,3),...
%     'Marker','.',...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColo','k');
% 
% hold(ah,'all')
%             
% % plot mode
% plot(dof.coords(:,1),z,...
%     'color','b',...
%     'Marker','o',...
%     'MarkerEdgeColor','b',...
%     'MarkerFaceColor','b');
% 
% % plot boundaries
% scatter(dof.bcoords(:,1),dof.bcoords(:,2),...
%     'MarkerEdgeColor','m',...
%     'MarkerFaceColor','m');
%             
% hold(ah,'off')
% 
% xlabel(ah,'Beam Length [ft]');
% ylabel(ah,'Modal Amplitude');
% 
% ylim(ah,[-1.5 1.5]);
% 
% grid(ah,'on');
% grid(ah,'minor');
% 
% 
% 
% 














