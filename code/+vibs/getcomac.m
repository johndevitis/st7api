function cm = getcomac(u1, u2)
% Syntax: cm = getcomac(u1, u2)
% 
% getcomac.m computes comac values for two modal arrays, u1 & u2.
% Complex mode check included to ensure correct comac values corresponding 
% to real/complex modes.
% 
% Input: 
%       u1 - modal vector/array 1 [n x m]
%       u2 - modal vector/array 2 [n x m]
% 
% Output: 
%       cm - coMAC value array [n x 1]
% 
% Written by:
%           John DeVitis
%           johndevitis@gmail.com
%           6/7/2012
% =========================================================================

% set up vars
[n , m] = size(u1);
[nn,mm] = size(u2);
cm = zeros(n,1);

% error screen arrays
if mm ~= m || nn ~= n
    error('Error: Modal vectors not consistent. Try again.');
end

% compute coMac
for ii = 1:n
    a = u1(ii,:).*u2(ii,:);
    b = u1(ii,:).*conj(u1(ii,:));
    c = u2(ii,:).*conj(u2(ii,:));
    
    cm(ii,1) = sum(a.^2)/(sum(b)*sum(c));
    
end