function nodeID = findNodes(uID, model)
%% findNodes
% 
% input:
%       model - 
%       uID - st7 model file identifier
% 
% Output:
%       IDnum - model node ID numbers
%
% 
% author: John Braley
% create date: 31-Oct-2016 14:40:32
	
% Pull all model nodes
nodes = node();
nodes.getNodes(uID);

coords = nodes.coords;

X = coords(:,1);
Y = coords(:,2);
Z = coords(:,3);

ecoords = model.edata.dof;
x = ecoords(:,1);

% Snap nodes to exeriment dof coordinates
[xx,yy,zz,nn] = nodeSnap3(X,Y,Z,x,y,z);



	
	
	
end
