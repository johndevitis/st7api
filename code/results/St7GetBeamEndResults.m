function beamResults = St7GetBeamEndResults(uID, beamNums, resultCaseNum)

global rtBeamForce stBeamGlobal
resultType = rtBeamForce;
resultSubType = stBeamGlobal;
numRes = 12;
numCol = 6;
beamResults = zeros(numRes,length(beamNums));

for ii = 1:length(beamNums)

    beamRes = zeros(12,1); % 6 Resultants for beam end 1 + 6 resultents for beam end 2
    [iErr, numCol, beamRes] = calllib('St7API', 'St7GetBeamResultEndPos',...
        uID, resultType, resultSubType, beamNums(ii), resultCaseNum, numCol, beamRes);
    beamResults(:,ii) = beamRes;
    HandleError(iErr);

end

end