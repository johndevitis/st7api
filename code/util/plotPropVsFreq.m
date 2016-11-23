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
    
    for ii = 1:steps
        results.freq(ii,:) = model(ii).solvers.freq;
        prop = model(ii).params.obj;
        results.para(ii) = prop.(model(ii).params.name);
    end
    
    plot(results.para,results.freq,'-o');
    if strcmp(model(1).params.scale,'log')
        set(ah,'XScale','log')	
    end
    
    for jj = 1:size(results.freq,2)
        label{jj} = ['Mode ' num2str(jj)];
    end
        
    legend(label)
    ylabel('freq (Hz)')
    xlabel(model(1).params.name)
  end
