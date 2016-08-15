%% Function makeindex
%
% *Description*: Developed so to enable users to quickly publish directories
% of code and details of the cross function and global variable dependancies. 
% 
%% Details
%  
% * Using the freely avalable grep tool this function parses m files in the
% current directory:
% * It will determine all the global variables used by the various files so
% it is easy to check for overlaps of possible conflicts. 
% * It will also show which functions (scripts) are called by others and
% which which function in this directory are called by your code. 
% * It then makes a html folder and documents subsiquently published code in an index.html file along with links to the published files.
%
%% Requirements/Usage
%  
% * Linux users: have grep. Windows users: download gnu grep for win32 setups, 
% <http://gnuwin32.sourceforge.net/packages/grep.htm>
% make sure setup directory is added to the windows PATH environment variable. 
% *Note:* For best results and a valid desciption setup your comment in
% your files like this one so you will have a valid description on the
% index.html page. Also name functions the same as the m file they are in
%
%
%% Inputs
%
% root  - parent directory to index
% opts  - options structure
%
% **opts structure contains** all name/value pairs of the Matlab publish
% options. the following name/value pairs are default:
% * username (Anon)
% * format (html)
% * evalCode (false)
% * outputDir (root) 
%
%% Example
%
% root = pwd;
%
% opts = 
% 
%      username: 'johndevitis'
%        format: 'html'
%      evalCode: 0
%     outputDir: 'C:\Users\John\Documents\MATLAB\repos\st7api\code\html'
% 
% makeindex(root,opts)
%
%% Authors
%
% The original version of this code was published on MathWorks File
% Exchange by the user Gavin Paul 2008: 
% (https://www.mathworks.com/matlabcentral/fileexchange/21476-html-folder-+index-html--shows-function-global-dependancies)
%
% This is a modified version by: John DeVitis (johndevitis@gmail.com) 2016

function makeindex(root,opts)

%% User Selectable Publish Options

todaysdate = date;      % creation date

% use rdir (from file exchange) to search 2 directories deep
current_dir = rdir(fullfile(root,'**','*.m'));   

% default publish options
publish_options.format = 'html';
publish_options.evalCode = false;

% make html folder on root if not there
outputDir = fullfile(root,'html');
if ~exist(outputDir); [~,~,~] = mkdir(outputDir); end;
publish_options.outputDir = outputDir;

% assign optional username
if nargin > 1
    if isfield(opts,'username')
    % if found, assign and 
    % remove from opts struct
    username = opts.username;
    opts = rmfield(opts,'username');
    end
else
    username = 'Anon';
end

% remove ignored names from current_dir struct
if nargin > 1 
    if isfield(opts,'ignore')
        chk = [];
        % loop file names in current directory
        for jj = 1:length(current_dir)
            [pth,nm,xt] = fileparts(current_dir(jj).name);
            % loop cell array of ignore names 
            for ii = 1:length(opts.ignore)
                [ipth,inm,ixt] = fileparts(opts.ignore{ii});                
                % see if names match
                if strcmp(inm,nm)
                    % if they dont, save index
                    chk = [chk jj]; 
                end
            end
        end
        % build save index
        ind = 1:length(current_dir);
        % remove rows of index
        ind = removerows(ind','ind',chk);
        % use chk to save by index
        current_dir = current_dir(ind);
        % remove field from structure 
        opts = rmfield(opts,'ignore');
    end
end

% apply optional publish paramters
if nargin > 1 
    names = fieldnames(opts);
    for ii = 1:length(names)
        publish_options.(names{ii}) = opts.(names{ii});
    end
end



% error screen mac vs pc
if ispc
    slashPos=findstr(root,'\');
else
    slashPos=findstr(root,'/');
end
directoryName=root(slashPos(end)+1:end);


%% Go through each m file, extract info and publish

currMfile=1; % m file index start number

tic

for i=1:size(current_dir,1)
    [b,c]=strtok(current_dir(i).name,'.');
    if strcmp(c(2:end),'m')
        mfilenames(currMfile).val=b;
        mfilenames(currMfile).description=[];
        mfilenames(currMfile).calledby=[];
        mfilenames(currMfile).calls=[];
        mfilenames(currMfile).globals=[];
        
        [result,output]=system(strcat('grep -H "',char(mfilenames(currMfile).val),'(" *.m'));
        if result==1 && ~isempty(output)
            error('Check grep is properly installed and env var is added to PATH! Go to a shell and type "grep" and make sure');
        end

%% Read description from comment headers of file (You should setup header like this file)
        tempfn = fopen(char([mfilenames(currMfile).val,'.m']));
        linebyline = textscan(tempfn,'%s','delimiter', '\n');
        current_line = 3;
        while ~strcmp(char(linebyline{1}{current_line}),'')    
            commentmarkpos=findstr(char(linebyline{1}{current_line}),'%');
            [remaining,nothing]=strtok(char(linebyline{1}{current_line}),'%');
            if isempty(mfilenames(currMfile).description) && (strcmp(remaining,'') ||...
                    strcmp(remaining,' ')) ||... 
                    isempty(mfilenames(currMfile).description) && isempty(commentmarkpos) ||...
                    current_line==size(linebyline{1},1)
                
                mfilenames(currMfile).description='<b> None Valid </b>';
                break;
            else
                if isempty(mfilenames(currMfile).description)
                    mfilenames(currMfile).description=remaining;
                else
                    mfilenames(currMfile).description=[mfilenames(currMfile).description,'<br>',remaining];
                end
            end      
            current_line=current_line+1;
        end

        fclose(tempfn);

%% Determine functions which calls this function
        while (result==0 && size(output,2)>0)
            [templine,output]=strtok(output,char(10));
            calledbyfile =strtrim(strtok(templine,'.'));
            if isempty(strfind(mfilenames(currMfile).calledby,calledbyfile )) &&...
                    ~strcmp(calledbyfile,mfilenames(currMfile).val)
                mfilenames(currMfile).calledby=[mfilenames(currMfile).calledby,' ',calledbyfile];
            end
        end
        
        [result,output]=system(['grep -H -w "global" ',mfilenames(currMfile).val,'.m']);

%% Determine globals used in this function
        while (result==0 && size(output,2)>0)
            [templine,output]=strtok(output,char(10));            
            [preceeding,globalvars]=strtok(templine,char(32));
            if ~isempty(preceeding) && ~strcmp(preceeding(end),'%') && strcmp(preceeding(end-5:end),'global')
                while size(globalvars,2)>0
                    [currentvar,globalvars]=strtok(globalvars,char(32));
                    if size(currentvar,2)>0 &&...
                            isempty(strfind(mfilenames(currMfile).globals,currentvar)) &&...
                            ~strcmp(currentvar,'global')
                      
                        try if strcmp(currentvar(end),';') && size(currentvar,2)>1;  currentvar=currentvar(1:end-1); end; end;
                        if isempty(strfind(mfilenames(currMfile).globals,strcat(currentvar,';')))
                            mfilenames(currMfile).globals=[mfilenames(currMfile).globals,currentvar,'; '];
                        end
                    end
                end
            end
        end

%% Publish file to HTML directory
        publish([mfilenames(currMfile).val,'.m'],publish_options);
        
        currMfile=currMfile+1;
    end
end

%check if we have found anything to publish
if ~exist('mfilenames','var')
    warning(['No m files found, please check current directory: ',root]);
end

%% Gather published filenames and generate links from the index page

for i=1:size(mfilenames,2)
    for j=1:size(mfilenames,2)
        %since we dont need to search through function which call the
        %present to see if they are called by the present one
        if i~=j && ~isempty(strfind(mfilenames(j).calledby,mfilenames(i).val))
            mfilenames(i).calls=[mfilenames(i).calls,' ',mfilenames(j).val];
        end
    end
end

%% Make index.html file

% Print Header
fid=fopen(fullfile(root,'index.html'),'w');
fprintf(fid,'%s\n\r%s\n\r%s\n\r%s\n\r%s\n\r','<html>','<head>',['<H1>Matlab Code: ',directoryName,'</H1>'],['<H2>',username,' ',todaysdate,'</h2>'],'</head>');
fprintf(fid,'%s\n\r','<table border="1" width="100%">');
fprintf(fid,'%s\n\r','<tr><th width="15%">File (function)</th><th width="26%">Description</th><th width="24%">Calls</th><th width="24%">Called By</th><th width="11%">Globals Used</th></tr>');


%% Go through and print out each line out
for i=1:size(mfilenames,2)
    fprintf(fid,'%s','<tr>');
    [pth,nm,xt] = fileparts(mfilenames(i).val);
    %Check that there is a filename otherwise don't make it a link
    if exist(fullfile(outputDir,[nm '.html']),'file') == 2 
        fprintf(fid,'%s\n\r',strcat('<td><a href="',fullfile(outputDir,[nm '.html']),'">',mfilenames(i).val,'</a></td>'));
    else
        fprintf(fid,'%s\n\r',strcat('<td>',fullfile(outputDir,nm),' (No HTML file)</td>'));
    end

    fprintf(fid,'%s',strcat('<td>',mfilenames(i).description,'&nbsp</td>'));
    fprintf(fid,'%s',strcat('<td>',mfilenames(i).calls,'&nbsp</td>'));    
    fprintf(fid,'%s',strcat('<td>',mfilenames(i).calledby,'&nbsp</td>'));
    fprintf(fid,'%s',strcat('<td>',mfilenames(i).globals,'&nbsp</td>'));

    fprintf(fid,'%s','</tr>');
end

fprintf(fid,'%s','</table> <br> Created by makeindex, &copy;  Gavin Paul 2008</body></html>');
fclose(fid);

toc

display('Publishing complete');

