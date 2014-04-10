function addpath_fastqp()

% path license
setenv('PATH_LICENSE_STRING','2069810742&Courtesy_License&&&USR&2013&14_12_2011&1000&PATH&GEN&31_12_2013&0_0_0&0&0_0');

addpath_drake;

addpath(fullfile(pwd,'build','matlab'));
addpath(fullfile(pwd,'matlab'));
addpath(fullfile(pwd,'matlab','controllers'));
addpath(fullfile(pwd,'matlab','planners'));
addpath(fullfile(pwd,'matlab','planners','footstep_planner'));
addpath(fullfile(pwd,'matlab','util'));
addpath(fullfile(pwd,'matlab','frames'));
addpath(fullfile(pwd,'matlab','systems'));

end
