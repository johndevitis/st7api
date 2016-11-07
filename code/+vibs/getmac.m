function m = getmac(u1, u2)
% Syntax: m = getmac(u1, u2)
% 
% getmac.m computes mac values for two modal arrays, u1 & u2.
% Complex mode check included to ensure correct mac values corresponding to
% real/complex modes.
% 
% Input: 
%       u1 - modal vector/array 1 [n1 x m1]
%       u2 - modal vector/array 2 [n2 x m2]
% 
% Output: 
%       m - MAC value array [n1 x n2]
% 
% Written by:
%           John DeVitis 2011
%           johndevitis@gmail.com
%
% Changelog:
%
%       11.13.2014 - jdv - add non Nan check/capability
% =========================================================================

% define variables
n1 = size(u1,2);
n2 = size(u2,2);
m = zeros(n1,n2);

% error screen
if isreal(u1) && isreal(u2)
    % compute mac for real arrays
    for ii=1:n1
        for jj=1:n2
            % index non NaN values
            ind = nonzeros([1:size(u1,1)]'.*~isnan(u1(:,ii)).*~isnan(u2(:,jj)));
            % get mac
            m(ii,jj)=(u1(ind,ii)'*u2(ind,jj))^2/...
                     ((u2(ind,jj)'*u2(ind,jj))*(u1(ind,ii)'*u1(ind,ii)));
        end
    end
else
    % compute mac for complex arrays
    for ii=1:n1
        for jj=1:n2
            % index non NaN values
            ind = nonzeros([1:size(u1,1)]'.*~isnan(u1(:,ii)).*~isnan(u2(:,jj)));
            % get mac
            m(ii,jj)=(u1(ind,ii)'*conj(u2(ind,jj)))^2/...
                     ((u2(ind,jj)'*conj(u2(ind,jj)))*(u1(ind,ii)'*conj(u1(ind,ii))));
        end
    end
end
     
    
    
    
    
    