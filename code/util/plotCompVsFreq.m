%% plotSectionVsFreq
% 
% used for api sensitivity studies
% 
% author: john braley
% create date: 13-Sep-2016 
function plotCompVsFreq(results,field)
	
    fh = figure('PaperPositionMode','auto');
    ah = axes;
    hold on
    steps = length(results);
    
    lins = {'+b','or','xg','*m','+r','og','xm','*b'};
    
    for jj = 1:5 %results(1).nfa.nmodes % loop modes
        mode = jj;
        for ii = 1:steps
            % get x value - material field value
            ca = results(ii).comp;
            xx = ca.(field)(1);  % plot material property value on x - axis
            
            % get y value - freq
            freq = results(ii).nfa.freq;
            yy = freq(mode);
            plot(xx,yy,lins{jj})
            hold on
        end
    end
    set(ah,'XScale','log')
	hold off
end
