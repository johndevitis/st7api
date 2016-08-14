%% check/snap user coords to model coords
function slave = snapcoords(master,slave)
    % error screen empty coords 
    if ~isfield(slave,'coords') 
        % if no coords, default to all nodes
        slave.coords = master.coords;
        slave.ind = master.coords(:,4);
        
    elseif size(slave.coords,2) < 3
        % if coords but no index, snap nodes
        [xx,yy,nn] = nodeSnap(master.coords(:,1),master.coords(:,2),...
                               slave.coords(:,1),slave.coords(:,2));
        % save st7 node index
        slave.coords(:,1) = xx;
        slave.coords(:,2) = yy;
        slave.ind = master.coords(nn,4); % reference st7 node index
    end
end