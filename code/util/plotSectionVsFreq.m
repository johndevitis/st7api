%% plotSectionVsFreq
% 
% used for api sensitivity studies
% 
% author: john braley
% create date: 13-Sep-2016 
function plotSectionVsFreq(results,field)
	
    fh = figure('PaperPositionMode','auto');
    ah = axes;
    hold on
    steps = length(results);
    
    lins = {'+b','or','xg','*m'};
    
    for jj = 1:results(1).nfa.nmodes % loop modes
        mode = jj;
        for ii = 1:steps
            % get x value - material field value
            sxn = results(ii).sections;
            xx = sxn.(field);  % plot material property value on x - axis
            
            % get y value - freq
            freq = results(ii).nfa.freq;
            yy = freq(mode);
            plot(xx,yy,lins{jj})
            hold on
        end
    end
    
	
end
