%% solver Function
% to be used with apish.m
% solvers - cell array with all of the solver instances
% jbb

function solver(uID,solvers)
    % Loop through cell array
    for ii = 1:length(solvers)
        if isa(solvers,'cell')
            solver = solvers{ii};
        else
            solver = solvers(ii);
        end
        %% NFA
        if isa(solver,'NFA') && solver.run == 1
            nfa = solver;
            % call api fcn
            nfa.runNFA(uID,nfa.nodeid);
        end

        %% LSA 
        if isa(solver,'LSA') && solver.run == 1
            lsa = solver;
            % call lsa solver
            lsa.runLSA(uID)
        end
    end
end
