function [xx,yy,nn] = nodeSnap(X,Y,x,y)
%% SYNTAX: [xx,yy,nn] = nodeSnap(X,Y,x,y)
% Snap slave coordinates to master coordinates
% 
% Inputs: 
%           X       master x coordinate [vector]
%           Y       master y coordinate [vector]
%           x       slave x coordinate [vector]
%           y       slave y coordinate [vector]
%
% Outputs:
%           xx      snapped slave coordinate [vector]
%           yy      snapped slave coordinate [vector]
%           nn      index for slave-to-master correlation [vector]
%
% jdv - johndevitis@gmail.com

%% Set up
% pre-allocate
xx = zeros(size(x));
yy = zeros(size(y));
nn = zeros(size(x));

%% Get location of residual nodes
% loop slave nodes
for ii = 1:length(x)
    
    % get residual for node(ii)
    residual = sqrt( (X - x(ii)).^2 + (Y - y(ii)).^2);
    
    % index lowest residual
    [~,ind] = min(residual);
    
    % assign global coordinates from lowest residual
    xx(ii) = X(ind);
    yy(ii) = Y(ind);
    nn(ii) = ind;
    
end