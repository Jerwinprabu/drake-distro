function rmpath_fastqp()

rmpath_drake;

% remove the fastqp control matlab util directory into the matlab path:
rmpath(fullfile(pwd,'build','matlab'));
rmpath(fullfile(pwd,'matlab'));
rmpath(fullfile(pwd,'matlab','controllers'));
rmpath(fullfile(pwd,'matlab','planners'));
rmpath(fullfile(pwd,'matlab','planners','footstep_planner'));
rmpath(fullfile(pwd,'matlab','util'));
rmpath(fullfile(pwd,'matlab','frames'));
rmpath(fullfile(pwd,'matlab','systems'));

end
