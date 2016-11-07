function DOF = findNodes(uID, model)
%% findNodes
% 
% input:
%       model - structure containing experimental data info
%       uID - st7 model file identifier
% 
% Output:
%       DOF - node structure containing corresponding model node info
%
% 
% author: John Braley
% create date: 31-Oct-2016 14:40:32
	
% Pull all model nodes
% define deck plane

nodes = node();
nodes.getNodes(uID);

coords = nodes.coords;

X = coords(:,1);
Y = coords(:,2);
Z = coords(:,3);

%% grab dof coordinates & convert to inches
x = model.edata.dof.x;
y = model.edata.dof.y;
z = model.edata.dof.z;

% Snap nodes to exeriment dof coordinates
[xx,yy,zz,nn] = nodeSnap3(X,Y,Z,x,y,z);

% Parse and Assign to vargout
DOF = node();
DOF.totalXYZ = nodes.totalXYZ(nn,:);
DOF.coords = nodes.coords(nn,:);
DOF.id = nodes.id(nn);
DOF.nnodes = length(nn);
DOF.units = nodes.units;

	
	
	
end
