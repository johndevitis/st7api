function beam = getBeamInfo(uID,beamNum)
%% getBeamInfo
% 
% 
% 
% author: john devitis
% create date: 15-Aug-2016 11:59:19
	
    [propNum,propName] = getPropertyInfo(uID,beamNum);
	materialName = getMaterialName(uID,propNum);
    sectionName = getSectionName(uID,propNum);
    
    [element,section,material] = getBeamPropertyData(uID,propNum);
    
    beam.property.num = propNum;
    beam.property.name = propName;
    
    beam.material.name = materialName;
    
    beam.section.name = sectionName;
    
    beam.numSlices = numSlices;
    beam.propData = propData;
    beam.element = element;
    beam.section = section;
    beam.material = material;
    
	
end

function [propNum,propName] = getPropertyInfo(uID,beamNum)
% get beam property number and name using beam number
    global tyBEAM ptBEAMPROP
    % get beam property number
    [iErr,propNum] = calllib('St7API','St7GetElementProperty',uID,tyBEAM,...
        beamNum,1);
    HandleError(iErr);
    % get beam prop name
    maxLen = 128; % max length of name
    propName = char(ones(1,maxLen)); % preallocate (don't use zeros!)
    [iErr,propName] = calllib('St7API','St7GetPropertyName',uID, ptBEAMPROP,...
        propNum,propName,maxLen);
    HandleError(iErr);    
end
 
function materialName = getMaterialName(uID,propNum)
% get material name by prop number
    global ptBEAMPROP
    maxLen = 128;
    materialName = char(ones(1,maxLen));
    [iErr,materialName] = calllib('St7API','St7GetMaterialName',uID,...
        ptBEAMPROP,propNum,materialName,maxLen);
    HandleError(iErr);
end

function sectionName = getSectionName(uID,propNum)
% get name of beam section using property number
    maxLen = 128; % max length of name
    sectionName = char(ones(1,maxLen)); % pre-al
    [iErr,sectionName] = calllib('St7API','St7GetBeamSectionName',uID,...
        propNum,sectionName,maxLen);
    HandleError(iErr);
end


function [numSlices,propData] = getSectionProps(uID,propNum)
% returns beam section property data assigned to the specified beam prop
    [iErr,numSlices,propData] = calllib('St7API','St7GetBeamSectionPropertyData',...
        uID,propNum,1,ones(1,11));
    HandleError(iErr);
   
end




