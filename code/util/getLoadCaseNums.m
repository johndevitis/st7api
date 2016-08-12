function lcNums = getLoadCaseNums(lcName,lcnames,beamNums,resultFlag)
%%
% searches cell array of load case names and finds each paired load case
% number for the desired array of beamNums.
%
% inputs:
%  lcName   - truck label/loadcase label. see data/ for list of brp opts
%  lcnames  - cell array vector of raw strings mined from LSL file
%  beamNums - vector of beam numbers to find in results file
%  resultFlag - 'BM2' for bending moment (flexure), 'SF2' for shear
%  
% original by nr
% refactored by jdv 06152016

    quantifier = {'Min';'Max'};         % search both min and max response
    lcNums = zeros(length(beamNums),2); % preallocate
    
    % Get result case numbers
    for ii = 1:length(beamNums)    
        for jj = 1:length(quantifier)  
            % look for beam End 1 first
            resultCaseName = ['Beam(' num2str(beamNums(ii)) ') End 1 ' resultFlag ' [' lcName '] (' quantifier{jj} ' Response)'];
            match = find(strcmp(lcnames,resultCaseName));
            % check for pair
            if isempty(match)
                % no match, look for End 2
                resultCaseName = ['Beam(' num2str(beamNums(ii)) ') End 2 ' resultFlag ' [' lcName '] (' quantifier{jj} ' Response)'];
                match = find(strcmp(lcnames,resultCaseName));    
                % check for End 2 match now
                if isempty(match)
                    % error screen null save
                    match = 0;
                    % update user
                    fprintf(['Beam ' num2str(beamNums(ii)) ' not found. \n']);
                end
            end
            % save flex
            lcNums(ii,jj) = match;                          
        end
    end
end
