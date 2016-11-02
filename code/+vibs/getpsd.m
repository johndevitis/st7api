function [pxx,f] = getpsd(data,nAvg,percOverlap,nfft,fs)
%% function [pxx,f] = getpsd(data,nAvg,percOverlap,nfft,fs)
%
% Inputs:
%       data            [time x nDOF] acceleration matrix
%       nAvg            number of data segments for averaging
%       percOverlap     percent overlap of data segments
%       nfft            specify nfft or leave empty for default
%       fs              sampling freq [hz]
%
% Outputs
%       pxx             [nfft x nDOF] one sided power spectral density 
%                       calculated via pwelch
%       f               frequency vector [hz]
%
% jdv 4/10/14

%% setup

window = floor(length(data)/nAvg);          % window length for nAvg
noverlap = floor(percOverlap/100*window);   % overlap length for averaging

%% get power spectral density
fprintf('\nPower Spectral Density\n');
% loop to populate
for ii = 1:size(data,2)
    fprintf(['\tDOF: ' num2str(ii) '\n']); 
    [pxx(:,ii),f] = pwelch(data(:,ii),window,noverlap,nfft,fs);
end


