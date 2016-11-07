function demo_pairModes()
%% demo_pairModes
% 
% 
% 
% author: john devitis
% create date: 31-Oct-2016 11:55:54
    import vibs.*
    fprintf('Pair Modes Demo\n');
    
    %% example 1: trivial case of exact pair
    ndof = 10; nmodes = 3;
    u1 = rand(ndof,nmodes);         % generate 'true' mode shape array
    id = vibs.pairModes(u1,u1);     % pair modes
    if all(id == [1 2 3])           % check for correct pair
        fprintf('\tSuccess\n');
    end
    
    %% example 2: flipped columns
    ndof = 10; nmodes = 3;
    u1 = rand(ndof,nmodes);         % generate 'true' mode shape array
    u2 = u1(:,fliplr(1:nmodes));    % flip columns of slave array
    id = vibs.pairModes(u1,u2);     % pair modes
    if all(id == [3 2 1])           % check for correct pair
        fprintf('\tSuccess\n');
    end
    
    %% example 3: columns flipped + extra + end placement
    ndof = 10; nmodes = 3;
    u1 = rand(ndof,nmodes);         % generate 'true' mode shape array
    u2 = u1(:,fliplr(1:nmodes));    % flip columns of slave array
    u2 = [rand(ndof,nmodes) u2];    % add random garbage in front
    id = vibs.pairModes(u1,u2);     % pair modes
    if all(id == [6 5 4])           % check for correct pair
        fprintf('\tSuccess\n');
    end
    
    %% example 4: ex3 + gaussian white noise (signal to noise = 15:1)
    ndof = 10; nmodes = 3;
    u1 = rand(ndof,nmodes);         % generate 'true' mode shape array
    u2 = awgn(u1,15);               % add white gaussian noise, 20 sig/noise
    u2 = u2(:,fliplr(1:nmodes));    % flip columns of slave array
    u2 = [rand(ndof,nmodes) u2];    % add random garbage in front
    id = vibs.pairModes(u1,u2);     % pair modes
    if all(id == [6 5 4])           % check for correct pair
        fprintf('\tSuccess\n');
    end
    
    %% example 5: non-random start shapes
    xx = [.5 1 1.5]*pi;
    for ii = 1:length(xx)
        u1(:,ii) = sin(linspace(0,xx(ii),10));
    end
    u2 = awgn(u1,5);               % add gaussian noise at sig/noise = 10
    u2 = u2(:,fliplr(1:nmodes));    % flip columns of slave array
    u2 = [rand(ndof,nmodes) u2];    % add random garbage in front
    id = vibs.pairModes(u1,u2);     % pair modes
    if all(id == [6 5 4])           % check for correct pair
        fprintf('\tSuccess\n');
    end
    
    figure; % plot signals
    subplot(2,1,1); plot(u1);
    subplot(2,1,2); plot(u2);
    
    % plot mac values
    m1 = getmac(u1,u1);        
    m2 = getmac(u1,u2);  
    m3 = getmac(u1,u2(:,id));  
    figure(); colormap Jet;
    subplot(3,1,1); imagesc(m1); colorbar; title('u1 v u1')
    subplot(3,1,2); imagesc(m2); colorbar; title('u1 v u2 raw')
    subplot(3,1,3); imagesc(m3); colorbar; title('u1 v u2 sorted')

    
    fprintf('Done demo.\n');
end

