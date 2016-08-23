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
    
    % save to results structure
    results.nodes = nodes;
    
    
%% Beam - broken

    % check for beam struct
    if isfield(model,'beam')
        beam = model.beam;
        out = getBeamInfo(uID,beam.num);
        results.beam = out;
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
