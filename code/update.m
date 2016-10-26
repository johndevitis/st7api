%% Main Function
% to be used with apish.m
% jdv

function results = update(uID,model)
%% Main function, edit as you like. 

%% Node 
% note the convention:
%  node() is the object,
%  nodes is the instance of the object.
    
    %     nodes = node();         % create instance of node class
    %     nodes.getUCSinfo(uID);  % get UCS info       
    %     nodes.getNodes(uID);    % index all nodes
        
    
    % assign restraints if present
    if isfield(model,'bc')
        bc = model.bc;
        if ~exist('nodes','var')
            nodes = node();         % create instance of node class
            nodes.getUCSinfo(uID);  % get UCS info 
        end
        nodes.setRestraint(uID,bc.nodeid,bc.fcase,bc.restraint);
    end

    % assign stiffness if present
    if isfield(model,'springs')
        % set node stiffnesses using st7indices
        springs = model.springs;
        if ~exist('nodes','var')
            nodes = node();         % create instance of node class
            nodes.getUCSinfo(uID);  % get UCS info 
        end
        nodes.setNodeK(uID,springs);
        results.springs = springs;
    end
    
    % Assign non-structural mass to nodes (mass applied to LC 1)
    if isfield(model,'NSMass')
        % set node non-structural mass
        nsm = model.NSMass;
        nsm.setNodeNSMass(uID);
        results.NSMass = nsm;        
    end
    
%     % save to results structure
%     results.nodes = nodes;
    
    
%% Beam - broken

    % check for beam struct
    if isfield(model,'beam')
        beam = model.beam;
        out = getBeamInfo(uID,beam.num);
        results.beam = out;
    end
    

%% Beam Material

    % check for material structure
    if isfield(model,'materials')
        beams = model.materials;
        % call get material fcn
        mat = beams.getBeamMaterial(uID);
        % Populate empty material property fields
        beams = fillempty(beams, mat);
        % set new material properties 
        beams.setBeamMaterial(uID)
        % save to results structure
        results.materials = beams;
    end
    
%% Beam Section
    % check for sections structure
    if isfield(model,'sections')
        beams = model.sections;
        % call get section fcn
        sxn = beams.getBeamSection(uID);
        % Populate empty section property fields
        beams = fillempty(beams, sxn);
        % set new section properties 
        beams.setBeamSection(uID)
        % save to results structure
        results.sections = beams;
    end
    
    % check for comp structure
    if isfield(model,'comp')
        connection = model.comp;
        % call get connection fcn
        stiffness = connection.getConnection(uID);
        % Populate empty section property fields
        connection = fillempty(connection, stiffness);
        % set new section properties 
        connection.setConnection(uID)
        % save to results structure
        results.comp = connection;
    end

%% Plate
    % check for deck structure (assumes material is to altered)
    if isfield(model,'deck')
        plate = model.deck;
        % call get plate material fcn
        mat = plate.getPlateMaterial(uID);
        %populate empty material property fields
        plate = fillempty(plate, mat);
        % set new material properties
        plate.setPlateMaterial
        % save reults to results structure
        results.deck = plate;
    end
    
    % check for deckt structure (assumes thickness is to altered)
    if isfield(model,'deckt')
        plate = model.deckt;
        % set new material properties
        plate.setPlateThickness(uID)
        % save reults to results structure
        results.deckt = plate;
    end
    
%% NFA
    if isfield(model,'nfa') && model.nfa.run == 1
        nfa = model.nfa;
        % call api fcn
        nfa.runNFA(uID);
        % save to model struct 
        results.nfa = nfa;
    end
         
%% LSA 
    if isfield(model,'lsa') && model.lsa.run == 1        
        lsa = model.lsa;
        % call lsa solver
        lsa.runLSA(uID)
        % save to modle struct
        results.lsa = lsa;
    end
end
