%% Main Function
% to be used with apish.m
% jdv

function results = main(uID,model)
%% Main function, edit as you like. 

    % index nodes at z=0
    % note the convention:
    %  node() is the object,
    %  nodes is the instance of the object.
    nodes = node();
    nodes.getNodes(uID,0);    
       
    % get UCS info for all nodes
    nodes.getUCSinfo(uID);
    
    % assign restraints if present
    if isfield(model,'bc')
        bc = model.bc;
        nodes.setRestraint(uID,bc.ind,bc.fcase,bc.restraint);
    end

    % assign stiffness if present
    if isfield(model,'springs')
        % set node stiffnesses using st7indices
        springs = model.springs;
        nodes.setNodeK(uID,springs);
        dof.springs = springs;
    end
    
    % save to results structure
    results.nodes = nodes;
    
    % check for beam struct
    if isfield(model,'beam')
        out = getBeamInfo(uID,model.beam.num);
        results.beam = out;
    end

    % Perform A-Priori NFA
    if isfield(model,'nfa') && model.nfa.run == 1
        nfa = model.nfa;
        % call api fcn
        nfa.runNFA(uID,results.nodes.ind);
        % save to model struct 
        results.nfa = nfa;
    end
        
        
    % Perform LSA Static Solver
    if isfield(model,'lsa') && model.lsa.run == 1        
        lsa = model.lsa;
        loads = lsa.loads;
        resps = lsa.resps;
        % check coords in load and response structs
        loads = snapcoords(dof,loads);
        resps = snapcoords(dof,resps);
        % call lsa solver
        res = get_lsa(uID,lsa.resultname, ...
                          loads.lc, loads.ind, loads.force,...
                          resps.lc, resps.ind);
        % save to stuct
        resps.disp = res; 
        lsa.loads = loads; 
        lsa.resps = resps;
        results.lsa = lsa;
    end
end
