%% publish index
%
% * need makefile.m and grep.m on search path
% 
% jdv 08142016

root = pwd;
opts.username = 'john devitis';
opts.ignore = {'St7APIConst'};

makeindex(root,opts)
