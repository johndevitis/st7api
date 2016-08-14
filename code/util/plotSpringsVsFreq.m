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
    
    for jj = 1:4
        mode = jj;
        for ii = 1:steps
            freq = results(ii).nfa.freq;
            springs = results(ii).dof.springs;


            yy = freq(mode);
            xx = ones(size(yy))*springs.Kt(1);
            plot(xx,yy,lins{jj})
            hold on
        end
    end
    
    set(ah,'XScale','log')	
	
end
