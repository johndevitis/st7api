function setParaBase(sys,model)
%% setParaBase
% 
% model - cell array of parameter objects
% 
% author: John Braley
% create date: 09-Nov-2016 11:59:51

% Initialize St7 Properties
APIop = apiOptions();
APIop.keepLoaded = 1;
APIop.keepOpen = 1;
% Grab property values from model
apish(@getModelProp,sys,model,APIop);

%% Populate base values

for ii = 1:length(model)
    if isa(model,'cell')
        param = model{ii};
    else
        param = model(ii);
    end
    prop = param.obj;
    if isempty(param.base)
        param.base = prop.(param.name);
    end
end
	
end
