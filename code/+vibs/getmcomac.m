function mcm = getmcomac(freq,u1)
%% Syntax: mcm = getmcomac(freq,u1)
%
% jdv 3/19/14

% set up vars
[~,n] = size(u1);
% a = zeros(size(u1));

% normalize modes
u1 = normalizeMode(u1);

% get comac
cm = getcomac(u1,u1);

% get modified comac
for ii = 1:n
    a(:,ii) = (1-cm).*(abs(u1(:,ii)))/(freq(ii))^2;
    mcm = sum(a,2);
end

% mcm = normalizeMode(mcm);