function nmodes = getNumModes(filename)
%% getNumModes
% 
% 
% 
% author: John Braley
% create date: 21-Nov-2016 10:40:08

% Search st7 log files for number of converged modes. Returns the number of
% modes.


% open file
[fid, errmsg] = fopen(filename);
   % error screen
   if ~isempty(errmsg)
       error(errmsg);
   end

% find the number using literals
literal = 'Natural Frequencies';      % start flag
exitflag = 'Mass Degrees '; % end flag

% loop for flags
flg = 0; cnt = 0; matches = [];
while ~feof(fid) && flg == 0    
  % read line
  tline = fgetl(fid);
  lit = strfind(tline, literal);   
    % check literal
    if ~isempty(lit) 
      cnt = cnt+1; 
    end 
  ext = strfind(tline, exitflag);  
  % check exitflag
  if ~isempty(ext)
      flg = 1;
  end   
  % check for save
  if cnt >= 1 && flg == 0
      % save line
      matches{cnt} = sprintf('%s',tline);
      % advance counter
      cnt = cnt+1;
  end   
end


% filter
%   find number after "Natural Frequencies"
lcnames = regexp(matches,'(?<=: )(.*)','match');
nmodes = str2double(lcnames{1}{:});
% close file
fclose(fid);	
end
