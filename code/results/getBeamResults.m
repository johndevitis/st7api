function results = getBeamResults(model,res,beamNums,lcNums)
%%
%
% returns:
% [beamNum, beamDesc, beamID]
% 
% jdv 06152016

    uID = 1;     % default st7 model id      
    results = []; % make sure this exists
    
    %-- API Execution Wrapper --%
    try
        results = Main(uID,model,res,lcNums,beamNums);
    catch   
        % force close errthang
        fprintf('Force close!\n');
        CloseAndUnload(uID);
        rethrow(lasterror);
    end
end

function results = Main(uID,model,res,lcNums,beamNums)
    % load api 
    InitializeSt7(); 
    % open model file
    St7OpenModelFile(uID, model.path, model.name, model.scratch)      
    % open result file
    St7OpenResultFile(uID,res.fullpath);
    
    % loop beam numbers
    for ii = 1:length(beamNums)     
        
        % get beam info
        [propNum,propName,sectionName] = getBeamInfo(uID,beamNums(ii));
        
        % save to results
        results.beamNum(ii) = beamNums(ii);
        results.propNum(ii) = propNum;
        results.propName{ii} = propName;
        results.sectionName{ii} = sectionName;
            
        % loop load case numbers for each beam 
        %  assuming 2 load cases, min and max
        beamResults = zeros(12,size(lcNums,2)); % preallocate 
        for jj = 1:size(lcNums,2)               
            % check for empty load case number 
            % (this will happen when load case is not found by
            % getLoadCaseNums)
            if lcNums(ii,jj) ~= 0
                % get beam results
                beamResults(:,jj) = extractBeamResults(uID,beamNums(ii),...
                    lcNums(ii,jj));
            end
        end
        
        % filter results for beam ii
        [M,P,V] = filterBeamResults(beamResults);

        % save to results struct
        results.M(ii,1) = M;
        results.P(ii,1) = P;
        results.V(ii,1) = V;
        
    end
    
    % Close all and unload library
    CloseAndUnload(uID);        
end

function [M,P,V] = filterBeamResults(beamres)
% filter absolute max response and pull out moment, shear, and axial
% TODO: generalize for any number of resultcases - currently only works for
% a max of 2 cases (for min/max)

    % find absolute max response
    % assume 2 load cases per beam -> min and max (positive/negative, etc)
    beamResults = max(abs(beamres(:,1)),abs(beamres(:,end)));
    
    % index moment, shear, and axial results
    M = max(abs(beamResults(4)), abs(beamResults(10)));
    P = max(abs(beamResults(1)), abs(beamResults(7)));
    V = max(abs(beamResults(5)), abs(beamResults(9)));

end

function beamResults = extractBeamResults(uID,bnum,lcnum)
% 6 resultants for each beam end
% beamResults - [12x1]
    global rtBeamForce stBeamGlobal
    numRes = 12; numCol = 6;
    beamResults = zeros(numRes,1);
    [iErr, numCol, beamResults] = calllib('St7API', 'St7GetBeamResultEndPos',...
        uID, rtBeamForce, stBeamGlobal, bnum, lcnum, numCol, beamResults);
    HandleError(iErr);
end

function [propNum,propName,sectionName] = getBeamInfo(uID,bnum)
% get property number, property name, and section name from beam number

    global tyBEAM ptBEAMPROP    
    
    % get beam property number
    [iErr,propNum] = calllib('St7API', 'St7GetElementProperty',uID,tyBEAM, ...
        bnum,1);
    HandleError(iErr);
    
    % get beam prop name
    maxLen = 128; % max length of name
    propName = char(ones(1,maxLen)); % preallocate (don't use zeros!)
    [iErr,propName] = calllib('St7API','St7GetPropertyName',uID, ptBEAMPROP,...
        propNum,propName,maxLen);
    HandleError(iErr);       
    
    % get beam section name
    sectionName = char(ones(1,maxLen)); % pre-al
    [iErr,sectionName] = calllib('St7API','St7GetBeamSectionName',uID,...
        propNum,sectionName,maxLen);
    HandleError(iErr);
end

