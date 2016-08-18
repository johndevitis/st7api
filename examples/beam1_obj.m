function obj = beam1_obj(para,beam,efreq)

    % set spring value
    beam.springs.Kr = [0 para 0];
    
    % call api for frequencies due to current para
    results = apish(@main,beam);
    
    % get frequencies
    afreq = results.nfa.freq;
    
    % form residual for each mode
    for ii = 1:results.nfa.nmodes
        obj(ii) = (afreq(ii)-efreq(ii))/efreq(ii);
    end
    %   return sum of squares as objective function value (this isn't
    %   necesasry for lsqnonlin)
    
    obj = sqrt(sum(sum(obj.^2),2));
    
    
end