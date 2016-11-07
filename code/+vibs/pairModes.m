function id = pairModes(u1,u2)
%% pairModes -> pair modes based on highest MAC value
% 
% input:
%   u1 - master mode shape [ndof x nmodes]
%   u2 - slave mode shape [ndof x nmodes]
%
% output: 
%   id - column index to pair such that u2(:,id) = u1
%
%   * demos and test cases available in vibs.examples.demo_pairModes
%
% example:
%     %% basic usage & robustness
%     xx = [.5 1 1.5]*pi;
%     for ii = 1:length(xx)
%        % generate 'master' column vectors
%        u1(:,ii) = sin(linspace(0,xx(ii),10));
%     end
%     ID = [3 2 1];                % deterministic modal order
%     u2 = awgn(u1,10);            % add gaussian noise at sig:noise = 10:1
%     u2 = u2(:,ID);               % flip columns of slave array
%     u2 = [rand(size(u1)) u2];    % add random garbage in front
%     id = vibs.pairModes(u1,u2);  % pair modes
% 
%     % plot signals
%     figure; 
%     subplot(2,1,1); plot(u1); title('master shapes');
%     subplot(2,1,2); plot(u2(:,id)); title('recovered shapes');
% 
%     % plot mac values
%     m1 = getmac(u1,u1);        
%     m2 = getmac(u1,u2);  
%     m3 = getmac(u1,u2(:,id));  
%     figure(); colormap Jet;
%     subplot(3,1,1); imagesc(m1); colorbar; title('u1 v u1')
%     subplot(3,1,2); imagesc(m2); colorbar; title('u1 v u2 raw')
%     subplot(3,1,3); imagesc(m3); colorbar; title('u1 v u2 sorted')
% 
% See also demo_pairModes
%
% author: john devitis 
% create date: 31-Oct-2016 11:15:53 
	import vibs.*  
	m = getmac(u1,u2);   % modal assurance criterion 
	[~,I] = max(m,[],2); % find best pairings
    id = I';
end
