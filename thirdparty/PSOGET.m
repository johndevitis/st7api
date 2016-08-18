function VAL = PSOGET(OPTIONS,name,default,flag)
%PSOGET Get PSO OPTIONS parameters.
%   VAL = PSOGET(OPTIONS,'NAME') extracts the value of the named parameter
%   from optimization options structure OPTIONS, returning an empty matrix if
%   the parameter value is not specified in OPTIONS.  It is sufficient to
%   type only the leading characters that uniquely identify the
%   parameter.  Case is ignored for parameter names.  [] is a valid OPTIONS
%   argument.
%
%   VAL = PSOGET(OPTIONS,'NAME',DEFAULT) extracts the named parameter as
%   above, but returns DEFAULT if the named parameter is not specified (is [])
%   in OPTIONS.  For example
%
%     val = PSOGET(opts,'TolX',1e-4);
%
%   returns val = 1e-4 if the TolX property is not specified in opts.
%
%   See also PSOSET, PSO



% This file contains a modified version of MATLAB function OPTIMGET.
% 
% Copyright (C) 2006 Brecht Donckels, BIOMATH, brecht.donckels@ugent.be
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details. 
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
% USA.



% undocumented usage for fast access with no error checking
if (nargin == 4) && isequal(flag,'fast')
   VAL = getknownfield(OPTIONS,name,default);
   return
end

if nargin < 2
  error('MATLAB:odeget:NotEnoughInputs','Not enough input arguments.');
end
if nargin < 3
  default = [];
end

if ~isempty(OPTIONS) && ~isa(OPTIONS,'struct')
  error('MATLAB:odeget:Arg1NotODESETstruct',...
        'First argument must be an options structure created with ODESET.');
end

if isempty(OPTIONS)
  VAL = default;
  return;
end

Names = [
    'SWARM_SIZE    '
    'COGNITIVE_ACC '
    'SOCIAL_ACC    '
    'MAX_ITER      '
    'MAX_TIME      '
    'MAX_FUN_EVALS '
    'TOLX          '
    'TOLFUN        '
    'DISPLAY       '
    'OUTPUT_FCN    '
    ];

names = lower(Names);

lowName = lower(name);
j = strmatch(lowName,names);
if isempty(j)               % if no matches
  error('MATLAB:odeget:InvalidPropName',...
        ['Unrecognized property name ''%s''.  ' ...
         'See ODESET for possibilities.'], name);
elseif length(j) > 1            % if more than one match
  % Check for any exact matches (in case any names are subsets of others)
  k = strmatch(lowName,names,'exact');
  if length(k) == 1
    j = k;
  else
    msg = sprintf('Ambiguous property name ''%s'' ', name);
    msg = [msg '(' deblank(Names(j(1),:))];
    for k = j(2:length(j))'
      msg = [msg ', ' deblank(Names(k,:))];
    end
    msg = sprintf('%s).', msg);
    error('MATLAB:odeget:AmbiguousPropName', msg);
  end
end

if any(strcmp(fieldnames(OPTIONS),deblank(Names(j,:))))
  VAL = OPTIONS.(deblank(Names(j,:)));
  if isempty(VAL)
    VAL = default;
  end
else
  VAL = default;
end

% --------------------------------------------------------------------------
function v = getknownfield(s, f, d)
%GETKNOWNFIELD  Get field f from struct s, or else yield default d.

if isfield(s,f)   % s could be empty.
  v = subsref(s, struct('type','.','subs',f));
  if isempty(v)
    v = d;
  end
else
  v = d;
end

