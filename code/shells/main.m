function model = main(uID,model)
%% Main function, edit as you like. 

    % Extract and index plane of nodes at z=0
    dof = getNodes(uID,0);    
    % save dof struct to model struct
    model.dof = dof;
    
    % Perform A-Priori NFA
    if isfield(model,'nfa')
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
        model.nfa = nfa;
    end
        
    % Perform LSA Static Solver
    if isfield(model,'lsa')        
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
        model.lsa = lsa;
    end
end
