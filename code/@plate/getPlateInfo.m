%% getPlateInfo
% 
% 
% 
% author: john devitis
% create date: 15-Aug-2016 12:02:38
function getPlateInfo(uID,propnum)
	
	plate.material = getMaterialName(uID,propnum)
	
	
	
end



%% get material name by property number
function materialName = getMaterialName(uID,propnum)
    global ptPLATEPROP
    [iErr,materialname] = calllib('St7API','St7GetMaterialName',uID,...
        ptPLATEPROP,propnum,'hi',50);
    HandleError(iErr)	
end