function [lambdas, feasibility, foot_centers] = scanWalkingTerrain(biped, traj, current_pos, nom_step_width)
% Scan out a grid of terrain along the robot's planned walking trajectory, then filter that terrain by its acceptability for stepping on. 
% @param traj either a BezierTraj or a DirectTraj
% @param current_pos where the center of the robot's feet currently is
% @retval lambdas linearly spaced points between 0 and 1 representing positions along the trajectory
% @retval feasibility a struct with 'right' and 'left' fields. If feasibility.right(n) == 1, then the right foot can be safely placed at the location along the trajectory given by lambdas(n)
% @retval foot_centers the center position of each foot at each lambda 

debug = false;

if nargin < 4
  nom_step_width = biped.nom_step_width;
end

foot_radius = sqrt(sum((biped.foot_contact_offsets.right.toe - biped.foot_contact_offsets.right.center).^2)) + 0.01;

lambdas = linspace(0, 1, 200);
traj_poses = traj.eval(lambdas);
if any(any(isnan(traj_poses)))
  error(['Got bad footstep trajectory data (NaN) at time: ', datestr(now())]);
end

traj_boundary_dist = biped.max_step_width + foot_radius;
x_min = min(traj_poses(1,:)) - traj_boundary_dist;
x_max = max(traj_poses(1,:)) + traj_boundary_dist;
y_min = min(traj_poses(2,:)) - traj_boundary_dist;
y_max = max(traj_poses(2,:)) + traj_boundary_dist;

sample_x = linspace(x_min, x_max, (x_max - x_min) / foot_radius * 5);
dx = sample_x(2) - sample_x(1);
sample_y = linspace(y_min, y_max, (y_max - y_min) / foot_radius * 5);
dy = sample_y(2) - sample_y(1);

[X , Y] = meshgrid(sample_x, sample_y);
X = reshape(X, 1, []);
Y = reshape(Y, 1, []);
[Z, ~] = biped.getTerrainHeight([X; Y]);

% HACK: we don't know the terrain height under the robot
Z(isnan(Z)) = current_pos(3);

X = reshape(X, length(sample_y), length(sample_x));
Y = reshape(Y, length(sample_y), length(sample_x));
Z = reshape(Z, length(sample_y), length(sample_x));
Z = medfilt2(Z);

Q = zeros(size(Z));
Q = bsxfun(@max, Q, abs(imfilter(Z, [1, -1])) - 0.03);
Q = bsxfun(@max, Q, abs(imfilter(Z, [1; -1])) - 0.03);
Q(isnan(Z)) = 1;
Q(Q > 0) = 1;


domain = zeros(ceil(2 * foot_radius / dy), ceil(2 * foot_radius / dx));
xy = [0;0];
for j = 1:size(domain, 1)
  xy(2) = (j - (size(domain, 1) / 2 + 0.5)) * dy;
  for k = 1:size(domain, 2)
    xy(1) = (k - (size(domain, 2) / 2 + 0.5)) * dx;
    dist_from_foot_center = sqrt(sum(xy.^2));
    if  dist_from_foot_center < foot_radius
%       domain(j, k) = foot_radius - dist_from_foot_center;
      domain(j, k) = 1;
    end
  end
end

F = ordfilt2(Q, length(find(domain)), domain);
    
% traj_poses = traj.eval(linspace(0, 1, 2*max([length(sample_x), length(sample_y)])));
foot_centers = struct('right', biped.stepCenter2FootCenter(traj_poses, 1, nom_step_width),...
                      'left', biped.stepCenter2FootCenter(traj_poses, 0, nom_step_width));
feasibility = struct('right', griddata(X, Y, F, foot_centers.right(1,:), foot_centers.right(2,:),'nearest') < 0.5,...
   'left', griddata(X, Y, F, foot_centers.left(1,:), foot_centers.left(2,:), 'nearest')< 0.5);


 
if debug
  plot_lcm_points([reshape(X, [], 1), reshape(Y, [], 1), reshape(Z, [], 1)], [reshape(F, [], 1), reshape(1-F, [], 1), reshape(zeros(size(F)), [], 1)], 71, 'Terrain Feasibility', 1, 1);
  figure(1)
  mesh(X, Y, Z)
  axis equal

  figure(2)
  clf
  mesh(X, Y, F)
  hold on
  plot3(foot_centers.right(1,:), foot_centers.right(2,:), ~feasibility.right, 'g.-')
  plot3(foot_centers.left(1,:), foot_centers.left(2,:), ~feasibility.left, 'b.-')
  axis equal
end

end