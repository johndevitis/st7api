function plot_beam_shape()
%% plot_beam_shape
% 
% 
% 
% author: 
% create date: 19-Aug-2016 10:50:56
	
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
	
	
	
end
