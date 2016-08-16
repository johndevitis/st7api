function getNodes(self,uID,zz)
%% get coordinate info in plane
% zz = 0; % index only at global z = 0 (RAMPS)
%
% 1. gets total nodes in model
% 2. checks for units (handles everything in feet)
% 3. scales to feet if necessary
% 4. loops all nodes, indexes plane if supplied (i.e. ramps deck nodes z=0)
% 5. looks for boundary nodes
% 6. returns dof structure
%
% outputs:
% 	dof.
% 		nnodes - total nodes 
% 		coords - all coordinates [x,y,z,ind] - st7 index = 1:length(coords)
% 		bcoords - boundary coordinates [x,y,z]
% 		totalXYZ - array of all nodal coordinates
%
% jdv 1/10/13; 1/29/13; 2/14/14; 09222015; 08122016
    fprintf('\t Getting spatial information... '); 
    
    global tyNODE
    
    % setup planar search
    if nargin < 2
        planeCheck = 0; 
    else
        planeCheck = 1; 
    end
    
    % get total nodes in model
    [iErr, nnodes] = calllib('St7API','St7GetTotal', uID, tyNODE, 0);
    HandleError(iErr);
    
    % get length units of model 
    [iErr, units] = calllib('St7API','St7GetUnits',uID,zeros(1,6));
    HandleError(iErr);
    
    % - get proper factor for conversion to feet (or not)
    if units(1) == 4 
        % disp units = inches
        scale = 12; 
    else
        % if units(1) = 3 then disp units = feet
        scale = 1;
    end

    % - Get geometry data
    totalXYZ = zeros(nnodes,3); 
    coords = []; 
    count = 1; % counter for looping
    for ii = 1:nnodes % loop all nodes to filter
        % get node(ii) xyz coord
        [iErr, totalXYZ(ii,:)] = calllib('St7API','St7GetNodeXYZ', uID, ii, totalXYZ(ii,:));
        HandleError(iErr);  
        if planeCheck
            % limit search to node.z_dim = zz
            if floor(totalXYZ(ii,3)) == zz || ceil(totalXYZ(ii,3)) == zz
                % assign to struct IN FEET
                coords(count,1) = totalXYZ(ii,1)/scale; % x - coord
                coords(count,2) = totalXYZ(ii,2)/scale; % y - coord
                coords(count,3) = zz; % z - coord
                coords(count,4) = ii; % dof index / strand7 node index
                count = count+1; % advance counter
            end
        else
            % assign all nodes to coord array
            coords(ii,:) = totalXYZ(ii,:);
        end
    end
    
    % find boundary nodes
    bcoords = getBoundaryNodes(coords);
    
    % save to object
    self.units = units;
    self.coords = coords;
    self.nnodes = nnodes;
    self.totalXYZ = totalXYZ;
    self.bcoords = bcoords;
    
    % update UI
    fprintf('Done. \n');     
end