%% Update Function
% to be used with apish.m
% jbb

function results = update(uID,optrun)
%% Main function, edit as you like. 

%% Get porperty names for material and section classes for future string comparison
info_m = ?material;
matprop = {info_m.PropertyList.Name};
info_s = ?section;
sxnprop = {info_s.PropertyList.Name};

model = optrun.modelPara;
%% Make changes to St7 Model
for ii = 1:length(model)
    para = model{ii}.obj;
    % Operate on st7 plate elements
    if isa(para,'plate')
        % Alter plate material
        if any(strcmp(model{ii}.name,matprop))
            % call get plate material fcn
            mat = para.getPlateMaterial(uID);
            %populate empty material property fields
            para = fillempty(para, mat);
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
            % call get material fcn
            mat = para.getBeamMaterial(uID);
            % Populate empty material property fields
            para = fillempty(para, mat);
            % set new material properties 
            para.setBeamMaterial(uID);
        elseif any(strcmp(model{ii}.name,sxnprop))
            % Alter section property
            % call get section fcn
            sxn = para.getBeamSection(uID);
            % Populate empty section property fields
            para = fillempty(para, sxn);
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
        % call get connection fcn
        vals = para.getConnection(uID);
        % Populate empty section property fields
        para = fillempty(para, vals);
        % set new section properties 
        para.setConnection(uID)
    end
end
     
%% NFA
if isa(optrun.solver,'NFA') && optrun.solver.run == 1
    nfa = optrun.solver;
    % call api fcn
    nfa.runNFA(uID,nfa.nodeid);
    % save to model struct 
    results.nfa = nfa;
end
         
%% LSA 
if isa(optrun.solver,'LSA') && optrun.solver.run == 1
    lsa = optrun.solver;
    % call lsa solver
    lsa.runLSA(uID)
    % save to modle struct
    results.lsa = lsa;
end
end
