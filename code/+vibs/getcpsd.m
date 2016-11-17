function [pxy,f] = getcpsd(data,refInd,nAvg,percOverlap,nfft,fs)
%% function [pxy,f] = getcpsd(data,refInd,nAvg,percOverlap,nfft,fs)
%
% Inputs:
%       data            [time x nDOF] acceleration matrix
%       refInd          vector of column indices - reference for cpsd               
%       nAvg            number of data segments for averaging
%       percOverlap     percent overlap of data segments
%       nfft            specify nfft or leave empty for default
%       fs              sampling freq [hz]
%
% Outputs
%       pxy             [nfft x nDOF x nRef] one sided cross power spectral density 
%                       calculated via pwelch
%       f               frequency vector [hz]
%
% jdv 4/10/14

%% setup

window = floor(length(data)/nAvg);           % window length for nAvg
noverlap = floor(percOverlap/100*window);    % overlap length for averaging

%% get cross power spectral density

% update UI
fprintf('\nForming Cross Power Spectral Densities... \n');

% loop to populate
for jj = 1:length(refInd)
    fprintf(['\t REF: ' num2str(jj) ' of ' num2str(length(refInd)) '\n']);
    
    for ii = 1:size(data,2)
        fprintf(['\t\t DOF: ' num2str(ii) ' of ' num2str(size(data,2)) '\n'])
        [pxy(ii,jj,:),f] = cpsd(data(:,ii),data(:,refInd(jj)),window,noverlap,nfft,fs);
    end
end

fprintf('Done. \n')

