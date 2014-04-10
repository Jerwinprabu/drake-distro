% csolve  Solves a custom quadratic program very rapidly.
%
% [vars, status] = csolve(params, settings)
%
% solves the convex optimization problem
%
%   minimize(quad_form(C*x + D*(Jdot*qd + J*qdd) - y0, Q) + (2*x_bar'*S + s1')*(A*x_bar + B*(Jdot*qd + J*qdd)) + w*quad_form(qddot_ref - qdd, eye(34)) + 0.00100001*quad_form(epsilon, eye(24)) + 1.0e - 08*quad_form(qdd, eye(34)) + 1.0e - 08*quad_form(lambda, eye(32)))
%   subject to
%     Hf*qdd + Cf == Gf'*lambda
%     Jp*qdd + Jpdot*qd == epsilon - Jp*qd
%     lambda >= 0
%     abs(epsilon) <= epsilon_max
%
% with variables
%  epsilon  24 x 1
%   lambda  32 x 1
%      qdd  34 x 1
%
% and parameters
%        A   4 x 4
%        B   4 x 2
%        C   2 x 4
%       Cf   6 x 1
%        D   2 x 2    diagonal
%       Gf  32 x 6
%       Hf   6 x 34
%        J   2 x 34
%     Jdot   2 x 34
%       Jp  24 x 34
%    Jpdot  24 x 34
%        Q   2 x 2    PSD, diagonal
%        S   4 x 4    PSD
% epsilon_max   1 x 1
%       qd  34 x 1
% qddot_ref  34 x 1
%       s1   4 x 1
%        w   1 x 1    positive
%        x   4 x 1
%    x_bar   4 x 1
%       y0   2 x 1
%
% Note:
%   - Check status.converged, which will be 1 if optimization succeeded.
%   - You don't have to specify settings if you don't want to.
%   - To hide output, use settings.verbose = 0.
%   - To change iterations, use settings.max_iters = 20.
%   - You may wish to compare with cvxsolve to check the solver is correct.
%
% Specify params.A, ..., params.y0, then run
%   [vars, status] = csolve(params, settings)
% Produced by CVXGEN, 2013-09-02 19:42:37 -0400.
% CVXGEN is Copyright (C) 2006-2012 Jacob Mattingley, jem@cvxgen.com.
% The code in this file is Copyright (C) 2006-2012 Jacob Mattingley.
% CVXGEN, or solvers produced by CVXGEN, cannot be used for commercial
% applications without prior written permission from Jacob Mattingley.

% Filename: csolve.m.
% Description: Help file for the Matlab solver interface.
