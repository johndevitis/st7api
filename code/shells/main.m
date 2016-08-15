%% Main Function
% to be used with apish.m
% jdv

function results = main(uID,model)
%% Main function, edit as you like. 

    % Extract and index plane of nodes at z=0
    dof = getNodes(uID,0);    
    
    % get node index
    % dof.coords - [x y z st7nodeid]
    nodes = dof.coords(:,4);
    
    % get UCS info for all nodes
    [ucsid,ucsname] = getUCSinfo(uID,dof.coords(:,4));
    dof.ucsid = ucsid;
    dof.ucsname = ucsname;

    % assign stiffness
    if isfield(model,'springs')
        % set node stiffnesses using st7indices
        springs = model.springs;
        setNodeK(uID,nodes,springs.Kfc,ucsid,springs.Kt,springs.Kr);
        dof.springs = springs;
    end
    
    % save dof struct
    results.dof = dof;

    
    % Perform A-Priori NFA
    if isfield(model,'nfa') && model.nfa.run == 1
        nfa = model.nfa;
        % snap dof coordinates to model nodes 
        nfa = snapcoords(dof,nfa);
        % call api fcn
        [U, freq,modalres] = getNFA(uID,nfa.resultname,nfa.nmodes,nfa.ind);
        % append to nfa struct
        nfa.U = U;
        nfa.freq = freq;
        nfa.modalres = modalres;
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
