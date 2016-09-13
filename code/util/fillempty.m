function obj1 = fillempty(obj1, obj2)
%% fillempty
% 
% fills empty fields in var1 with values from corresponding fields in var2
% 
% author: John Braley
% create date: 08-Sep-2016 16:11:14
	
fields = fieldnames(obj2);
numfields = length(fields);

for ii = 1:numfields
    if isprop(obj1,fields{ii}) && isempty(obj1.(fields{ii}))
        obj1.(fields{ii}) = obj2.(fields{ii});
    end
end	
	
end
