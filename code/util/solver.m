%% solver Function
% to be used with apish.m
% solvers - cell array with all of the solver instances
% jbb

function results = solver(uID,solvers)
    % Loop through cell array
    for ii = 1:length(solvers)
        %% NFA
        if isa(solvers{ii},'NFA') && solvers{ii}.run == 1
            nfa = solvers{ii};
            % call api fcn
            nfa.runNFA(uID,nfa.nodeid);
        end

        %% LSA 
        if isa(solvers{ii},'LSA') && solvers{ii}.run == 1
            lsa = solvers{ii};
            % call lsa solver
            lsa.runLSA(uID)
        end
    end

results = 0;
end
