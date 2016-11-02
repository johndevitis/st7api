function nms = normalizeMode(ms)
% function nms = normalizeMode(ms)
% jdv 5/14/2012
nms = zeros(size(ms));
[~, imax] = max(abs(ms));
for ii = 1:size(ms,2)
    nms(:,ii) = ms(:,ii)/ms(imax(ii),ii);
end
