%% plotSpringsVsFreq
% 
% used for api sensitivity studies
% 
% author: john devitis
% create date: 14-Aug-2016 14:58:56
function plotSpringsVsFreq(results)
	
    fh = figure('PaperPositionMode','auto');
    ah = axes;
    hold on
    steps = length(results);
    
    lins = {'+b','or','xg','*m'};
    
    for jj = 1:results(1).nfa.nmodes % loop modes
        mode = jj;
        for ii = 1:steps
            % get x value - discrete spring stiffness
            springs = results(ii).springs;
            xx = springs.Kr(1,2);  % plot spring k about y
            
            % get y value - freq
            freq = results(ii).nfa.freq;
            yy = freq(mode);
            plot(xx,yy,lins{jj})
            hold on
        end
    end
    
    set(ah,'XScale','log')	
	
end
