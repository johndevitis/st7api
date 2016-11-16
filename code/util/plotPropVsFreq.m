%% plotSpringsVsFreq
% 
% used for api sensitivity studies
% 
% author: john braley
% create date: 13-Sep-2016 
function plotPropVsFreq(model)
	
    fh = figure('PaperPositionMode','auto');
    ah = axes;
    hold on
    steps = length(model);
    
    lins = {'+b','or','xg','*m'};
    
    for jj = 1:model(1).solvers.nmodes % loop modes
        mode = jj;
        for ii = 1:steps
            % get x value - material field value
            beam = model(ii).params.obj;
            results = model(ii).solvers;
            xx = beam.(model(ii).params.name);  % plot material property value on x - axis
            
            % get y value - freq
            freq = results.freq;
            yy = freq(mode);
            plot(xx,yy); %,lins{jj})
            hold on
        end
    end
    if strcmp(model(1).params.scale,'log')
        set(ah,'XScale','log')	
    end
end
