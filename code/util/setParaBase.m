function setParaBase(run)
%% setParaBase
% 
% 
% 
% author: John Braley
% create date: 09-Nov-2016 11:59:51

% Initialize St7 Properties
APIop = apiOptions();
APIop.keepLoaded = 1;
APIop.keepOpen = 1;
% Grab property values from model
apish(@getModelProp,run,APIop);

%% Populate base values
model = run.modelPara;
for ii = 1:length(model)
    para = model{ii}.obj;
    if isempty(model{ii}.base)
        model{ii}.base = para.(model{ii}.name);
    end
end
	
end
