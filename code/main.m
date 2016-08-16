%% Main Function
% to be used with apish.m
% jdv

function results = main(uID,model)
%% Main function, edit as you like. 

    % index nodes at z=0
    nodes = node();
    nodes.getNodes(uID,0);    
       
    % get UCS info for all nodes
    node.getUCSinfo(uID);
    
    % assign restraints
    

    % assign stiffness
    if isfield(model,'springs')
        % set node stiffnesses using st7indices
        springs = model.springs;
        nodes.setNodeK(uID,nodeInd,springs.Kfc,ucsid,springs.Kt,springs.Kr);
        dof.springs = springs;
    end
    
    % save dof struct
    results.nodes;
    
    % check for beam struct
    if isfield(model,'beam')
        out = getBeamInfo(uID,model.beam.num);
        results.beam = out;
    end

    % Perform A-Priori NFA
    if isfield(model,'nfa') && model.nfa.run == 1
        nfa = model.nfa;
        % call api fcn
        [nfa.U,nfa.freq,nfa.modal] = NFA.runNFA(uID,nfa.name,nfa.nmodes,nodeInd);
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
