%% publish index
%
% * need makefile.m and grep.m on search path
% 
% jdv 08142016

root = 'C:\Users\John\Documents\MATLAB\repos\st7api\code';
opts.username = 'john devitis';
opts.ignore = {'St7APIConst'};

makeindex(root,opts)
