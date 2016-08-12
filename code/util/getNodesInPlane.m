function dof = getNodesInPlane(uID,zz)
%% get coordinate info in plane
% zz = 0; % filter only z = 0 (RAMPS)
% jdv 1/10/13; 1/29/13; 2/14/14; 09222015

    global tyNODE
    
    % update ui
    fprintf('\t Getting spatial information... '); 
    
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
    coords = []; ind = [];
    count = 1; % counter for looping
    for ii = 1:nnodes % loop all nodes to filter
        % get node(ii) xyz coord
        [iErr, totalXYZ(ii,:)] = calllib('St7API','St7GetNodeXYZ', uID, ii, totalXYZ(ii,:));
        HandleError(iErr);  
        % limit search to node.z_dim = zz
        if floor(totalXYZ(ii,3)) == zz || ceil(totalXYZ(ii,3)) == zz
            % assign to struct IN FEET
            coords(count,1) = totalXYZ(ii,1)/scale; % x - coord
            coords(count,2) = totalXYZ(ii,2)/scale; % y - coord
            coords(count,3) = zz; % z - coord
            coords(count,4) = ii; % dof index
            count = count+1; % advance counter
        end
    end
    
    % find boundary nodes
    bcoords = get_boundarynodes(coords);
    
    % save to structure
    dof.coords = coords;
    dof.nnodes = nnodes;
    dof.totalXYZ = totalXYZ;
    dof.bcoords = bcoords;
    
    % update UI
    fprintf('Done. \n');     
end