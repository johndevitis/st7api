function setBeamProperty(uID,propnum,materialname)
%% setBeamProperty
% 
% 
% 
% author: john devitis
% create date: 15-Aug-2016 11:44:18
	global ptBEAMPROP ptPLATEPROP
	
    % set material name
	iErr = calllib('St7API','St7SetMaterialName',uID,ptBEAMPROP,propnum,...
        materialname);
    HandleError(iErr)
    
    % get material name by propnum
    [iErr,materialname] = calllib('St7API','St7GetMaterialName',uID,...
        ptBEAMPROP,propnum,'hi',50);
    HandleError(iErr)
	
end
