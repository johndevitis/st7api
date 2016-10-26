function grid1_obj(para,run,edata)
%% grid1_obj
% 
% Applies parameter changes to St7 model, runs NFA solver, and computes
% difference between model results and experimental data
% 
% author: John Braley
% create date: 26-Oct-2016 15:26:52

% para  -    new model parameter values
% run -   structure containing all the model and updating info
% edata -   experimental data

% api options
APIop = apiOptions();
APIop.keepLoaded = 1;
APIop.keepOpen = 1;

for ii = 1:length(para)
    % Write beam element I11 value
    if isa(run.parameters.(run.paraind(ii)).obj,'beam')
        run.parameters.(run.paraind(ii)).obj.I11 = para(ii);
    end
    % Write composite action element stiffness
    if isa(run.parameters.(run.paraind(ii)).obj,'connection')
        run.parameters.(run.paraind(ii)).obj.Tstiffness(1:2) = para(ii);
    end
    % Write deck stiffness (E)
    if isa(run.parameters.(run.paraind(ii)).obj,'plate')
        run.parameters.(run.paraind(ii)).obj.E = para(ii);
    end
    
	
	
	
end
