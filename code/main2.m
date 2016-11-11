%% Update Function
% to be used with apish.m
% jbb

function results = main2(uID,model)
%% Main function, edit as you like. 

% model contains all model parameters to be altered as well as any solver
% and system info

%% Get porperty names for material and section classes for future string comparison
info_m = ?material;
matprop = {info_m.PropertyList.Name};
info_s = ?section;
sxnprop = {info_s.PropertyList.Name};

% fields in model
fields = fieldnames(model);
numPara = length(fields);

%% Make changes to St7 Model
for ii = 1:numPara
    para = model.(fields{ii});
    
    % Operate on st7 plate elements
    if isa(para,'plate')
        % Alter plate material
        if any(strcmp(model{ii}.name,matprop))
            % set new material properties
            para.setPlateMaterial
        else
            % set new plate thickness
            para.setPlateThickness(uID)
        end
    end

    % Operate on st7 beam elements
    if isa(para,'beam')
        % Alter material property
        if any(strcmp(model{ii}.name,matprop))
            % set new material properties 
            para.setBeamMaterial(uID);
        elseif any(strcmp(model{ii}.name,sxnprop))
            % Alter section property
            % set new section properties 
            para.setBeamSection(uID)
        end
    end

    % Operate on nodes
    if isa(para,'node')
        % set node non-structural mass
        if strcmp(model{ii}.name,'Mns')
            para.setNodeNSMass(uID); 
        end
    end

    % Apply boundary restraints
    if isa(para,'boundaryNode')
        if ~exist('nodes','var')
            nodes = node();         % create instance of node class
            nodes.getUCSinfo(uID);  % get UCS info 
        end
        nodes.setRestraint(uID,para.nodeid,para.fcase,para.restraint);
    end

    % Alter node stiffness
    if isa(para, 'spring')
        % set node stiffnesses using st7indices
        if ~exist('nodes','var')
            nodes = node();         % create instance of node class
            nodes.getUCSinfo(uID);  % get UCS info 
        end
        nodes.setNodeK(uID,para);
    end

    % Operate on st7 connection elements
    if isa(para,'connection')
        % Change stiffness    
        % set new section properties 
        para.setConnection(uID)
    end
     
    %% NFA
    if isa(para,'NFA') && para.run == 1
        nfa = optrun.solver;
        % grab node ids from edata
        nfa.nodeid = optrun.edata.nodes.id;
        % call api fcn
        nfa.runNFA(uID,nfa.nodeid);
        % save to model struct 
    %     results.nfa = nfa;
    end

    %% LSA 
    if isa(para,'LSA') && para.run == 1
        lsa = optrun.solver;
        % call lsa solver
        lsa.runLSA(uID)
        % save to modle struct
    %     results.lsa = lsa;
    end
end

results = 0;
end
