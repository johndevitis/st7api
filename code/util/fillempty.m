function var1 = fillempty(var1, var2)
%% fillempty
% 
% fills empty fields in var1 with values from corresponding fields in var2
% 
% author: John Braley
% create date: 08-Sep-2016 16:11:14
	
fields = fieldnames(var2);
numfields = length(fields);

for ii = 1:numfields
    if isfield(var1,fields(ii)) && isempty(var1.fields(ii))
        var1.fields(ii) = var2.fields(ii);
    end
end	
	
end
