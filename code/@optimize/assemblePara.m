function assemblePara(self)
%% assemblePara
% 
% takes structure 'parameters', loops through fields and populates
% "optimize" instance
% 
% author: John Braley
% create date: 26-Oct-2016 14:50:10
pp = self.modelPara;
for ii = 1:length(pp)
    self.paraind{ii} = pp{ii}.name;
    para = pp{ii};
    if ~isempty(para.uba)
    self.ub(ii) = para.uba;
    end
    if ~isempty(para.lba)
    self.lb(ii) = para.lba;
    end
    if ~isempty(para.starta)
    self.start(ii) = para.starta;
    end
end
