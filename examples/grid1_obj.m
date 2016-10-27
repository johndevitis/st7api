function obj = grid1_obj(para,optrun,edata)
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

for ii = 1:length(para)
    % Assign new model parameter value to appropriate parameter object
    optrun.modelPara{ii}.obj.(optrun.modelPara{ii}.name) = para(ii);
end
results.paraVal = para;
results.paraName = optrun.paraind;

% api options
APIop = apiOptions();
APIop.keepLoaded = 1;
APIop.keepOpen = 1;

% call api to get frequencies due to current para
results = apish(@update,optrun,APIop);

% get frequencies
afreq = results.nfa.freq;
    
% form residual for each mode
efreq = edata.efreq;
for ii = 1:results.nfa.nmodes
    obj(ii) = (afreq(ii)-efreq(ii))/efreq(ii);
end
%   return sum of squares as objective function value (this isn't
%   necesasry for lsqnonlin)

obj = sqrt(sum(sum(obj.^2),2));


