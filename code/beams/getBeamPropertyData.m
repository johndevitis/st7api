function [elemData,section,material] = getBeamPropertyData(uID,propNum)
%% getBeamPropertyData
% 
% get beam property data and return sorted structures
% 
% inputs:
%
% uID
% propNum   - beam property number
%
% author: john devitis
% create date: 15-Aug-2016 15:41:56
	    
    % get beam properties
    [iErr,eleIndices,secData,matData] = calllib('St7API',...
        'St7GetBeamPropertyData',uID,propNum,ones(1,4),ones(1,19),ones(1,3));
    HandleError(iErr);  

    % get option lists pertaining to element properties
    [elementType,sectionType,mirrorType,compTwist] = beamPropertyOptions();
    
    % advance 1 (due to St7 0 indexing)
    eleIndices = eleIndices + 1;
    elemData(1) = elementType(eleIndices(1));
    elemData(2) = sectionType(eleIndices(2));
    elemData(3) = mirrorType(eleIndices(3));
    elemData(4) = compTwist(eleIndices(4));
    
    % assign section paramters
    section.area = secData(1);
    section.I11 = secData(2);
    section.I22 = secData(3);
    section.J = secData(4);
    section.SL1 = secData(5);
    section.SL2  = secData(6);
    section.SA1 = secData(7);
    section.SA2 = secData(8);
    section.XBAR = secData(9);
    section.YBAR = secData(10);
    section.ANGLE = secData(11);
    section.D1 = secData(12);
    section.D2 = secData(13);
    section.D3 = secData(14);
    section.T1 = secData(15);
    section.T2 = secData(16);
    section.T3 = secData(17);
    section.GapA = secData(18);
    section.GapB = secData(19);
    
    % assign material parameters
    material.modulus = matData(1);
    material.poisson = matData(2);
    material.density = matData(3);	
	
	
end
