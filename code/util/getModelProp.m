function getModelProp(uID,model)
%% getModelProp
% 
% Pulls propmeter properties from model and populates propmeter object
% 
% model - cell array of propmeter objects
% author: John Braley
% create date: 09-Nov-2016 10:43:28
%% Get porperty names for material and section classes for future string comparison
info_m = ?material;
matprop = {info_m.PropertyList.Name};
info_s = ?section;
sxnprop = {info_s.PropertyList.Name};

%% Pull properties from St7 Model
for ii = 1:length(model)
    if isa(model,'cell')
        Para = model{ii};
    else
        Para = model(ii);
    end
    prop = Para.obj;
    % Operate on st7 plate elements
    if isa(prop,'plate')
        % Alter plate material
        if any(strcmp(Para.name,matprop))
            % call get plate material fcn
            mat = prop.getPlateMaterial(uID);
            %populate empty material property fields
            prop = fillempty(prop, mat);
        else
            % get plate thickness
            thick = prop.getPlateThickness(uID);
            %populate empty fields
            prop = fillempty(prop, thick);
        end
    end

    % Operate on st7 beam elements
    if isa(prop,'beam')
        % Alter material property
        if any(strcmp(Para.name,matprop))
            % call get material fcn
            mat = prop.getBeamMaterial(uID);
            % Populate empty material property fields
            prop = fillempty(prop, mat);
        elseif any(strcmp(Para.name,sxnprop))
            % Alter section property
            % call get section fcn
            sxn = prop.getBeamSection(uID);
            % Populate empty section property fields
            prop = fillempty(prop, sxn);
        end
    end

    % Operate on nodes
    if isa(prop,'node')
        % get node non-structural mass
        if strcmp(Para.name,'Mns')
            nsm = prop.getNodeNSMass(uID); 
            prop.Mns = nsm(1);
        end
    end

%     % Apply boundary restraints
%     if isa(prop,'boundaryNode')
%         if ~exist('nodes','var')
%             nodes = node();         % create instance of node class
%             nodes.getUCSinfo(uID);  % get UCS info 
%         end
%         nodes.setRestraint(uID,prop.nodeid,prop.fcase,prop.restraint);
%     end

    % Operate on node stiffness
    if isa(prop, 'spring')
        % set node stiffnesses using st7indices
        if ~exist('nodes','var')
            nodes = node();         % create instance of node class
            nodes.getUCSinfo(uID);  % get UCS info 
        end
        % get node stiffness
        [Kt,Kr] = nodes.getNodeK(uID,prop);
        % parse stiffness values for direction
        if size(unique(Kt,'rows'),1)==1
            prop.KtX = Kt(1,1);
            prop.KtY = Kt(1,2);
            prop.KtZ = Kt(1,3);
        end
        if size(unique(Kr,'rows'),1)==1
            prop.KrX = Kr(1,1);
            prop.KrY = Kr(1,2);
            prop.KrZ = Kr(1,3);
        end
        % Populate empty stiffness fields
        prop = fillempty(prop, spring);
        
    end

    % Operate on st7 connection elements
    if isa(prop,'connection')
        % Change stiffness    
        % call get connection fcn
        vals = prop.getConnection(uID);
        % Populate empty section property fields
        prop = fillempty(prop, vals);
    end
end
	
fprintf('Done. \n');
	
end
