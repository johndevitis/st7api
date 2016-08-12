%% Beam1 - Sensitivity Study Example
%
%
% jdv 08122016

%% Setup 

% st7 file info
sys.pathname = 'C:\Users\John\Documents\MATLAB\repos\st7api\models';
sys.filename = 'beam1.st7';
sys.scratchpath = 'C:Temp';

% use the api shell to pull node info

model.sys = sys; % assign info to model struct

model = apish(model);
