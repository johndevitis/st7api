function publishAll(root)
%%
%
% jdv 08232016

    files = rdir(root);
    
    % loop files
    for ii = 1:length(files)
        if ~files(ii).isdir && ~isempty(regexp(files(ii).name,'\w*(\.m)?', ...
                'ONCE'))
            publish(files(ii).name);
        end
    end
    

end