function yy = getrms(xx)
%% function yy = getrms(xx)
%
% Get room mean square of vector or matrix xx where:
%   xx = [ns x n]
%
% jdv 4/10/14; 12092015

% setup
[~,nn] = size(xx);
yy = zeros(1,nn);

% calc rms
for ii = 1:nn           % loop columns
    aa = xx(:,ii).^2;   % square
    bb = mean(aa);      % average
    cc = sqrt(bb);      % square root
    yy(ii) = cc;        % assign 
end


%     z = xx.^2;    % get x squared
%     a = mean(z); % get average
%     yy = sqrt(a); % get sqrt

