function lcnames = getLoadCaseNames(filename)
%% lcnames = getLoadCaseNames(filename)
%
% Search st7 log files for load case names. Returns a cell array of 
% strings.
%
% jdv 03162016

% open file
[fid, errmsg] = fopen(filename);
    % error screen
    if ~isempty(errmsg)
        error(errmsg);
    end

% find the burried names using literals
literal = 'LOAD CASES';      % start flag
exitflag = 'STORAGE SCHEME'; % end flag

% loop for flags
flg = 0; cnt = 0; matches = [];
while ~feof(fid) && flg == 0    
   % read line
   tline = fgetl(fid);
   lit = strfind(tline, literal);
   ext = strfind(tline, exitflag);      
   % check literal
   if ~isempty(lit) 
       cnt = cnt+1;    
   end   
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

% remove trailing white space
matches = matches(1:end-1);
% filter
lcnames = regexp(matches,'(?<=")(.*?)+(?=")','match');
% close file
fclose(fid);

% unnest nested cell arrays
lcnames = [lcnames{:}];

end

