%% Main Function
% to be used with apish.m
% jdv

function results = main(uID,model)
%% Main function, edit as you like. 

%% Node 
% note the convention:
%  node() is the object,
%  nodes is the instance of the object.
    
    nodes = node();         % create instance of node class
    nodes.getNodes(uID);    % index all nodes
    nodes.getUCSinfo(uID);  % get UCS info 
    
    % assign restraints if present
    if isfield(model,'bc')
        bc = model.bc;
        nodes.setRestraint(uID,bc.nodeid,bc.fcase,bc.restraint);
    end

    % assign stiffness if present
    if isfield(model,'springs')
        % set node stiffnesses using st7indices
        springs = model.springs;
        nodes.setNodeK(uID,springs);
        results.springs = springs;
    end
    
    if isfield(model,'NSMass')
        % set node non-structural mass
        nsm = model.NSMass;
        nsm.setNodeNSMass(uID);
        results.NSMass = nsm;        
    end
    
    % save to results structure
    results.nodes = nodes;
    
    
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
    % check for material structure
    if isfield(model,'sections')
        beams = model.sections;
        % call get material fcn
        sxn = beams.getBeamSection(uID);
        % Populate empty material property fields
        beams = fillempty(beams, sxn);
        % set new material properties 
        beams.setBeamSection(uID)
        % save to results structure
        results.sections = beams;
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
