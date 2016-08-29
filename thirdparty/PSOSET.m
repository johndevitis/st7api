function OPTIONS = PSOSET(varargin)
%PSOSET Create/alter particle swarm optimization (PSO) OPTIONS structure.
%   OPTIONS = PSOSET('PARAM1',VALUE1,'PARAM2',VALUE2,...) creates an
%   optimization options structure OPTIONS in which the named parameters have
%   the specified values.  Any unspecified parameters are set to [] (parameters
%   with value [] indicate to use the default value for that parameter when
%   OPTIONS is passed to the optimization function). It is sufficient to type
%   only the leading characters that uniquely identify the parameter.  Case is
%   ignored for parameter names.
%   NOTE: For values that are strings, the complete string is required.
%
%   OPTIONS = PSOSET(OLDOPTS,'PARAM1',VALUE1,...) creates a copy of OLDOPTS
%   with the named parameters altered with the specified values.
%
%   OPTIONS = PSOSET(OLDOPTS,NEWOPTS) combines an existing options structure
%   OLDOPTS with a new options structure NEWOPTS.  Any parameters in NEWOPTS
%   with non-empty values overwrite the corresponding old parameters in
%   OLDOPTS.
%
%   PSOSET with no input arguments and no output arguments displays all
%   parameter names and their possible values, with defaults shown in {}
%   when the default is the same for all functions that use that option -- use
%   PSOSET(OPTIMFUNCTION) to see options for a specific function.
%
%   OPTIONS = PSOSET (with no input arguments) creates an options structure
%   OPTIONS where all the fields are set to [].

%   See also PSOGET, PSO



% This file contains a modified version of MATLAB function OPTIMSET.
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



% Print out possible values of properties.
if (nargin == 0) && (nargout == 0)
    fprintf('                  SWARM_SIZE: [ positive scalar {10} ]\n');
    fprintf('               COGNITIVE_ACC: [ positive scalar {2.05} ]\n');
    fprintf('                  SOCIAL_ACC: [ positive scalar {2.05} ]\n');
    fprintf('                    MAX_ITER: [ positive scalar {2500} ]\n');
    fprintf('                    MAX_TIME: [ positive scalar {2500} ]\n');
    fprintf('               MAX_FUN_EVALS: [ positive scalar {2500} ]\n');
    fprintf('                        TOLX: [ positive scalar {1e-6} ]\n');
    fprintf('                      TOLFUN: [ positive scalar {1e-6} ]\n');
    fprintf('                     DISPLAY: [ ''iter'' or ''none'' {''iter''} ]\n');
    fprintf('                  OUTPUT_FCN: [ function_handle ]\n');
    fprintf('\n');
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

m = size(Names,1);
names = lower(Names);

% Combine all leading options structures o1, o2, ... in odeset(o1,o2,...).
OPTIONS = [];
for j = 1:m
  OPTIONS.(deblank(Names(j,:))) = [];
end
i = 1;
while i <= nargin
  arg = varargin{i};
  if ischar(arg)                         % arg is an option name
    break;
  end
  if ~isempty(arg)                      % [] is a valid options argument
    if ~isa(arg,'struct')
      error('MATLAB:odeset:NoPropNameOrStruct',...
            ['Expected argument %d to be a string property name ' ...
                     'or an options structure\ncreated with SIMANSET.'], i);
    end
    for j = 1:m
      if any(strcmp(fieldnames(arg),deblank(Names(j,:))))
        val = arg.(deblank(Names(j,:)));
      else
        val = [];
      end
      if ~isempty(val)
        OPTIONS.(deblank(Names(j,:))) = val;
      end
    end
  end
  i = i + 1;
end

% A finite state machine to parse name-value pairs.
if rem(nargin-i+1,2) ~= 0
  error('MATLAB:odeset:ArgNameValueMismatch',...
        'Arguments must occur in name-value pairs.');
end
expectval = 0;                          % start expecting a name, not a value
while i <= nargin
  arg = varargin{i};
    
  if ~expectval
    if ~ischar(arg)
      error('MATLAB:odeset:NoPropName',...
            'Expected argument %d to be a string property name.', i);
    end
    
    lowArg = lower(arg);
    j = strmatch(lowArg,names);
    if isempty(j)                       % if no matches
      error('MATLAB:odeset:InvalidPropName',...
            'Unrecognized property name ''%s''.', arg);
    elseif length(j) > 1                % if more than one match
      % Check for any exact matches (in case any names are subsets of others)
      k = strmatch(lowArg,names,'exact');
      if length(k) == 1
        j = k;
      else
        msg = sprintf('Ambiguous property name ''%s'' ', arg);
        msg = [msg '(' deblank(Names(j(1),:))];
        for k = j(2:length(j))'
          msg = [msg ', ' deblank(Names(k,:))];
        end
        msg = sprintf('%s).', msg);
        error('MATLAB:odeset:AmbiguousPropName', msg);
      end
    end
    expectval = 1;                      % we expect a value next
    
  else
    OPTIONS.(deblank(Names(j,:))) = arg;
    expectval = 0;
      
  end
  i = i + 1;
end

if expectval
  error('MATLAB:odeset:NoValueForProp',...
        'Expected value for property ''%s''.', arg);
end

end