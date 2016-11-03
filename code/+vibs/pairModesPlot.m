function fh = pairModesPlot(u1,u2)
%% pairModesPlot
% 
% 
% 
% author: john devitis
% create date: 03-Nov-2016 14:22:02
	import vibs.*
    
    % pair modes
    id = pairModes(u1,u2);
    
    % get mac values
    m1 = getmac(u1,u1);        
    m2 = getmac(u1,u2);  
    m3 = getmac(u1,u2(:,id));  
    
    % setup figure
    fh = figure('Name','Mode Pairing Results',...
                'Position',[680 151 387 827]);
    colormap Jet
    
    % set up plots
	subplot(3,1,1); imagesc(m1); colorbar; title('u1 v u1')
    subplot(3,1,2); imagesc(m2); colorbar; title('u1 v u2 raw')
    subplot(3,1,3); imagesc(m3); colorbar; title('u1 v u2 paired')
	
end
