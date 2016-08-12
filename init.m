function init()
%% init
%
% when called, this startup fcn adds all folders and subfolders in its root
% directory to matlab's search path
%
% jdv 06/22/2016

    % add all folders/files in parent dir to matlab path
    fname = which('init.m');    % get loc of loadrating/
    pname = fileparts(fname);   % break up full path
    addpath(genpath(pname));    % add full parent dir to namespace

end

