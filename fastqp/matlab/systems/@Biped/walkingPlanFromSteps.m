function [support_times, supports, comtraj, foottraj, V, zmptraj] = walkingPlanFromSteps(biped, x0, footsteps, footstep_opts,Qy)

nq = getNumDOF(biped);
q0 = x0(1:nq);
kinsol = doKinematics(biped,q0);

[zmptraj,foottraj, support_times, supports] = planZMPTraj(biped, q0, footsteps, footstep_opts);
zmptraj = setOutputFrame(zmptraj,desiredZMP);
%% construct ZMP feedback controller
com = getCOM(biped,kinsol);
foot_pos = contactPositions(biped,kinsol,biped.foot_bodies_idx);
zfeet = mean(foot_pos(3,:));

% get COM traj from desired ZMP traj
options.com0 = com(1:2);
[~,~,comtraj] = LinearInvertedPendulum.ZMPtrackerClosedForm(com(3)-zfeet,zmptraj,options);

% get COM traj from desired ZMP traj
if sizecheck(Qy,[2 2])
  options.Qy=diag([0; 0; 0; 0; diag(Qy)]);
else
  options.Qy=Qy;
end
options.use_tvlqr = true;
lipm = LinearInvertedPendulum(com(3)-zfeet);
[c,V] = lipm.ZMPtracker(zmptraj,options);

