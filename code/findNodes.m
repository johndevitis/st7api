function findNodes(uID, nodes)
%% findNodes
% 
% input:
%       nodes - node or deckNode object
%       uID - st7 model file identifier
% 
% Output:
%       DOF - node structure containing corresponding model node info
%
% 
% author: John Braley
% create date: 31-Oct-2016 14:40:32
	
% Pull all model nodes

if isa(nodes,'deckNode')
    if ~isempty(nodes.elevation)
        zz = nodes.elevation;
    else
        zz = 0;
    end
    nodes.getNodes(uID,zz); % pull just deck nodes
else
    allnodes = node();
    allnodes.getNodes(uID); % pull all nodes
    if ~isempty(nodes.coords)
        coords = allnodes.coords;

        X = coords(:,1);
        Y = coords(:,2);
        Z = coords(:,3);

        %% grab dof coordinates & convert to inches
        x = nodes.coords(:,1);
        y = nodes.coords(:,2);
        z = nodes.coords(:,3);

        % Snap nodes to exeriment dof coordinates
        [xx,yy,zz,nn] = nodeSnap3(X,Y,Z,x,y,z);
        % Parse and Assign to vargout
        nodes.totalXYZ = allnodes.totalXYZ(nn,:);
        nodes.coords = allnodes.coords(nn,:);
        nodes.id = allnodes.id(nn);
        nodes.nnodes = length(nn);
        nodes.units = allnodes.units;        
    end
    
end






	
	
	
end
