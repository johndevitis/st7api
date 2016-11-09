function results = getModelProp(uID,run)
%% getModelProp
% 
% Pulls parameter properties from model and populates parameter object
% 
% author: John Braley
% create date: 09-Nov-2016 10:43:28
%% Get porperty names for material and section classes for future string comparison
info_m = ?material;
matprop = {info_m.PropertyList.Name};
info_s = ?section;
sxnprop = {info_s.PropertyList.Name};

model = run.modelPara;
%% Pull properties from St7 Model
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
        else
            % get plate thickness
            thick = para.getPlateThickness(uID);
            %populate empty fields
            para = fillempty(para, thick);
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
        elseif any(strcmp(model{ii}.name,sxnprop))
            % Alter section property
            % call get section fcn
            sxn = para.getBeamSection(uID);
            % Populate empty section property fields
            para = fillempty(para, sxn);
        end
    end

    % Operate on nodes
    if isa(para,'node')
        % get node non-structural mass
        if strcmp(model{ii}.name,'Mns')
            para.getNodeNSMass(uID); 
        end
    end

%     % Apply boundary restraints
%     if isa(para,'boundaryNode')
%         if ~exist('nodes','var')
%             nodes = node();         % create instance of node class
%             nodes.getUCSinfo(uID);  % get UCS info 
%         end
%         nodes.setRestraint(uID,para.nodeid,para.fcase,para.restraint);
%     end

    % Operate on node stiffness
    if isa(para, 'spring')
        % set node stiffnesses using st7indices
        if ~exist('nodes','var')
            nodes = node();         % create instance of node class
            nodes.getUCSinfo(uID);  % get UCS info 
        end
        % get node stiffness
        [Kt,Kr] = nodes.getNodeK(uID,para);
        % parse stiffness values for direction
        if length(unique(Kt))==1
            spring.KtX = Kt(1,1);
            spring.KtY = Kt(1,2);
            spring.KtZ = Kt(1,3);
        end
        if length(unique(Kr))==1
            spring.KrX = Kr(1,1);
            spring.KrY = Kr(1,2);
            spring.KrZ = Kr(1,3);
        end
        % Populate empty stiffness fields
        para = fillempty(para, spring);
        
    end

    % Operate on st7 connection elements
    if isa(para,'connection')
        % Change stiffness    
        % call get connection fcn
        vals = para.getConnection(uID);
        % Populate empty section property fields
        para = fillempty(para, vals);
    end
end
	
% hotfix for output argument requirement for apish wrapper
results =0;
	
end
