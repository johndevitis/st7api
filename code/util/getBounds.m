%% getBoundaryNodes 
% function to extract adn return boundary nodes from an x,y coordinate
% array. 
% 
% **note** assumes z coordinates = 0
%
% input:
% * coords = [n x 2] array of (x,y) coordinates. 
%
% output:
% * bcoords = [n x 3] array of (x,y,z) coordinates. note that the function
% returns zeros for the z dimension. 
% 
% drm jdv 2/14/14; 5/28/14;
function bcoords = getBounds(xcoords, ycoords)
    % setup
    x = xcoords;
    y = ycoords;
    % sort nodes
    fprintf('\tSorting boundary nodes... ');
    gridColumn = unique(y);
    nearEdge = zeros(length(gridColumn));
    farEdge  = zeros(length(gridColumn));
    for ii = 1:length(gridColumn)
       nearEdge(ii,1) = min(x(y == gridColumn(ii)));
       nearEdge(ii,2) = gridColumn(ii);
       farEdge(ii,1) = max(x(y == gridColumn(ii)));
       farEdge(ii,2) = gridColumn(ii);
    end
    xb = [nearEdge(:,1); farEdge(:,1)];
    yb = [nearEdge(:,2); farEdge(:,2)];
    zb = zeros(size(xb));
    % save results
    bcoords = [xb yb zb];
    fprintf('Done.');
end