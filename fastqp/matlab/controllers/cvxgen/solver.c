/* Produced by CVXGEN, 2013-09-02 19:42:48 -0400.  */
/* CVXGEN is Copyright (C) 2006-2012 Jacob Mattingley, jem@cvxgen.com. */
/* The code in this file is Copyright (C) 2006-2012 Jacob Mattingley. */
/* CVXGEN, or solvers produced by CVXGEN, cannot be used for commercial */
/* applications without prior written permission from Jacob Mattingley. */

/* Filename: solver.c. */
/* Description: Main solver file. */
#include "solver.h"
double eval_gap(void) {
  int i;
  double gap;
  gap = 0;
  for (i = 0; i < 104; i++)
    gap += work.z[i]*work.s[i];
  return gap;
}
void set_defaults(void) {
  settings.resid_tol = 1e-6;
  settings.eps = 1e-4;
  settings.max_iters = 25;
  settings.refine_steps = 1;
  settings.s_init = 1;
  settings.z_init = 1;
  settings.debug = 0;
  settings.verbose = 1;
  settings.verbose_refinement = 0;
  settings.better_start = 1;
  settings.kkt_reg = 1e-7;
}
void setup_pointers(void) {
  work.y = work.x + 116;
  work.s = work.x + 148;
  work.z = work.x + 252;
  vars.epsilon = work.x + 0;
  vars.lambda = work.x + 24;
  vars.qdd = work.x + 56;
}
void setup_indexing(void) {
  setup_pointers();
}
void set_start(void) {
  int i;
  for (i = 0; i < 116; i++)
    work.x[i] = 0;
  for (i = 0; i < 32; i++)
    work.y[i] = 0;
  for (i = 0; i < 104; i++)
    work.s[i] = (work.h[i] > 0) ? work.h[i] : settings.s_init;
  for (i = 0; i < 104; i++)
    work.z[i] = settings.z_init;
}
double eval_objv(void) {
  int i;
  double objv;
  /* Borrow space in work.rhs. */
  multbyP(work.rhs, work.x);
  objv = 0;
  for (i = 0; i < 116; i++)
    objv += work.x[i]*work.rhs[i];
  objv *= 0.5;
  for (i = 0; i < 116; i++)
    objv += work.q[i]*work.x[i];
  objv += ((2*(params.x_bar[0]*params.S[0]+params.x_bar[1]*params.S[1]+params.x_bar[2]*params.S[2]+params.x_bar[3]*params.S[3])+params.s1[0])*params.A[0]*params.x_bar[2]+(2*(params.x_bar[0]*params.S[4]+params.x_bar[1]*params.S[5]+params.x_bar[2]*params.S[6]+params.x_bar[3]*params.S[7])+params.s1[1])*params.A[1]*params.x_bar[3]+(2*(params.x_bar[0]*params.S[8]+params.x_bar[1]*params.S[9]+params.x_bar[2]*params.S[10]+params.x_bar[3]*params.S[11])+params.s1[2])*(params.B[0]*(params.Jdot[0]*params.qd[0]+params.Jdot[2]*params.qd[1]+params.Jdot[4]*params.qd[2]+params.Jdot[6]*params.qd[3]+params.Jdot[8]*params.qd[4]+params.Jdot[10]*params.qd[5]+params.Jdot[12]*params.qd[6]+params.Jdot[14]*params.qd[7]+params.Jdot[16]*params.qd[8]+params.Jdot[18]*params.qd[9]+params.Jdot[20]*params.qd[10]+params.Jdot[22]*params.qd[11]+params.Jdot[24]*params.qd[12]+params.Jdot[26]*params.qd[13]+params.Jdot[28]*params.qd[14]+params.Jdot[30]*params.qd[15]+params.Jdot[32]*params.qd[16]+params.Jdot[34]*params.qd[17]+params.Jdot[36]*params.qd[18]+params.Jdot[38]*params.qd[19]+params.Jdot[40]*params.qd[20]+params.Jdot[42]*params.qd[21]+params.Jdot[44]*params.qd[22]+params.Jdot[46]*params.qd[23]+params.Jdot[48]*params.qd[24]+params.Jdot[50]*params.qd[25]+params.Jdot[52]*params.qd[26]+params.Jdot[54]*params.qd[27]+params.Jdot[56]*params.qd[28]+params.Jdot[58]*params.qd[29]+params.Jdot[60]*params.qd[30]+params.Jdot[62]*params.qd[31]+params.Jdot[64]*params.qd[32]+params.Jdot[66]*params.qd[33]))+(2*(params.x_bar[0]*params.S[12]+params.x_bar[1]*params.S[13]+params.x_bar[2]*params.S[14]+params.x_bar[3]*params.S[15])+params.s1[3])*(params.B[1]*(params.Jdot[1]*params.qd[0]+params.Jdot[3]*params.qd[1]+params.Jdot[5]*params.qd[2]+params.Jdot[7]*params.qd[3]+params.Jdot[9]*params.qd[4]+params.Jdot[11]*params.qd[5]+params.Jdot[13]*params.qd[6]+params.Jdot[15]*params.qd[7]+params.Jdot[17]*params.qd[8]+params.Jdot[19]*params.qd[9]+params.Jdot[21]*params.qd[10]+params.Jdot[23]*params.qd[11]+params.Jdot[25]*params.qd[12]+params.Jdot[27]*params.qd[13]+params.Jdot[29]*params.qd[14]+params.Jdot[31]*params.qd[15]+params.Jdot[33]*params.qd[16]+params.Jdot[35]*params.qd[17]+params.Jdot[37]*params.qd[18]+params.Jdot[39]*params.qd[19]+params.Jdot[41]*params.qd[20]+params.Jdot[43]*params.qd[21]+params.Jdot[45]*params.qd[22]+params.Jdot[47]*params.qd[23]+params.Jdot[49]*params.qd[24]+params.Jdot[51]*params.qd[25]+params.Jdot[53]*params.qd[26]+params.Jdot[55]*params.qd[27]+params.Jdot[57]*params.qd[28]+params.Jdot[59]*params.qd[29]+params.Jdot[61]*params.qd[30]+params.Jdot[63]*params.qd[31]+params.Jdot[65]*params.qd[32]+params.Jdot[67]*params.qd[33])))+params.w[0]*work.quad_98374471680[0];
  return objv;
}
void fillrhs_aff(void) {
  int i;
  double *r1, *r2, *r3, *r4;
  r1 = work.rhs;
  r2 = work.rhs + 116;
  r3 = work.rhs + 220;
  r4 = work.rhs + 324;
  /* r1 = -A^Ty - G^Tz - Px - q. */
  multbymAT(r1, work.y);
  multbymGT(work.buffer, work.z);
  for (i = 0; i < 116; i++)
    r1[i] += work.buffer[i];
  multbyP(work.buffer, work.x);
  for (i = 0; i < 116; i++)
    r1[i] -= work.buffer[i] + work.q[i];
  /* r2 = -z. */
  for (i = 0; i < 104; i++)
    r2[i] = -work.z[i];
  /* r3 = -Gx - s + h. */
  multbymG(r3, work.x);
  for (i = 0; i < 104; i++)
    r3[i] += -work.s[i] + work.h[i];
  /* r4 = -Ax + b. */
  multbymA(r4, work.x);
  for (i = 0; i < 32; i++)
    r4[i] += work.b[i];
}
void fillrhs_cc(void) {
  int i;
  double *r2;
  double *ds_aff, *dz_aff;
  double mu;
  double alpha;
  double sigma;
  double smu;
  double minval;
  r2 = work.rhs + 116;
  ds_aff = work.lhs_aff + 116;
  dz_aff = work.lhs_aff + 220;
  mu = 0;
  for (i = 0; i < 104; i++)
    mu += work.s[i]*work.z[i];
  /* Don't finish calculating mu quite yet. */
  /* Find min(min(ds./s), min(dz./z)). */
  minval = 0;
  for (i = 0; i < 104; i++)
    if (ds_aff[i] < minval*work.s[i])
      minval = ds_aff[i]/work.s[i];
  for (i = 0; i < 104; i++)
    if (dz_aff[i] < minval*work.z[i])
      minval = dz_aff[i]/work.z[i];
  /* Find alpha. */
  if (-1 < minval)
      alpha = 1;
  else
      alpha = -1/minval;
  sigma = 0;
  for (i = 0; i < 104; i++)
    sigma += (work.s[i] + alpha*ds_aff[i])*
      (work.z[i] + alpha*dz_aff[i]);
  sigma /= mu;
  sigma = sigma*sigma*sigma;
  /* Finish calculating mu now. */
  mu *= 0.009615384615384616;
  smu = sigma*mu;
  /* Fill-in the rhs. */
  for (i = 0; i < 116; i++)
    work.rhs[i] = 0;
  for (i = 220; i < 356; i++)
    work.rhs[i] = 0;
  for (i = 0; i < 104; i++)
    r2[i] = work.s_inv[i]*(smu - ds_aff[i]*dz_aff[i]);
}
void refine(double *target, double *var) {
  int i, j;
  double *residual = work.buffer;
  double norm2;
  double *new_var = work.buffer2;
  for (j = 0; j < settings.refine_steps; j++) {
    norm2 = 0;
    matrix_multiply(residual, var);
    for (i = 0; i < 356; i++) {
      residual[i] = residual[i] - target[i];
      norm2 += residual[i]*residual[i];
    }
#ifndef ZERO_LIBRARY_MODE
    if (settings.verbose_refinement) {
      if (j == 0)
        printf("Initial residual before refinement has norm squared %.6g.\n", norm2);
      else
        printf("After refinement we get squared norm %.6g.\n", norm2);
    }
#endif
    /* Solve to find new_var = KKT \ (target - A*var). */
    ldl_solve(residual, new_var);
    /* Update var += new_var, or var += KKT \ (target - A*var). */
    for (i = 0; i < 356; i++) {
      var[i] -= new_var[i];
    }
  }
#ifndef ZERO_LIBRARY_MODE
  if (settings.verbose_refinement) {
    /* Check the residual once more, but only if we're reporting it, since */
    /* it's expensive. */
    norm2 = 0;
    matrix_multiply(residual, var);
    for (i = 0; i < 356; i++) {
      residual[i] = residual[i] - target[i];
      norm2 += residual[i]*residual[i];
    }
    if (j == 0)
      printf("Initial residual before refinement has norm squared %.6g.\n", norm2);
    else
      printf("After refinement we get squared norm %.6g.\n", norm2);
  }
#endif
}
double calc_ineq_resid_squared(void) {
  /* Calculates the norm ||-Gx - s + h||. */
  double norm2_squared;
  int i;
  /* Find -Gx. */
  multbymG(work.buffer, work.x);
  /* Add -s + h. */
  for (i = 0; i < 104; i++)
    work.buffer[i] += -work.s[i] + work.h[i];
  /* Now find the squared norm. */
  norm2_squared = 0;
  for (i = 0; i < 104; i++)
    norm2_squared += work.buffer[i]*work.buffer[i];
  return norm2_squared;
}
double calc_eq_resid_squared(void) {
  /* Calculates the norm ||-Ax + b||. */
  double norm2_squared;
  int i;
  /* Find -Ax. */
  multbymA(work.buffer, work.x);
  /* Add +b. */
  for (i = 0; i < 32; i++)
    work.buffer[i] += work.b[i];
  /* Now find the squared norm. */
  norm2_squared = 0;
  for (i = 0; i < 32; i++)
    norm2_squared += work.buffer[i]*work.buffer[i];
  return norm2_squared;
}
void better_start(void) {
  /* Calculates a better starting point, using a similar approach to CVXOPT. */
  /* Not yet speed optimized. */
  int i;
  double *x, *s, *z, *y;
  double alpha;
  work.block_33[0] = -1;
  /* Make sure sinvz is 1 to make hijacked KKT system ok. */
  for (i = 0; i < 104; i++)
    work.s_inv_z[i] = 1;
  fill_KKT();
  ldl_factor();
  fillrhs_start();
  /* Borrow work.lhs_aff for the solution. */
  ldl_solve(work.rhs, work.lhs_aff);
  /* Don't do any refinement for now. Precision doesn't matter too much. */
  x = work.lhs_aff;
  s = work.lhs_aff + 116;
  z = work.lhs_aff + 220;
  y = work.lhs_aff + 324;
  /* Just set x and y as is. */
  for (i = 0; i < 116; i++)
    work.x[i] = x[i];
  for (i = 0; i < 32; i++)
    work.y[i] = y[i];
  /* Now complete the initialization. Start with s. */
  /* Must have alpha > max(z). */
  alpha = -1e99;
  for (i = 0; i < 104; i++)
    if (alpha < z[i])
      alpha = z[i];
  if (alpha < 0) {
    for (i = 0; i < 104; i++)
      work.s[i] = -z[i];
  } else {
    alpha += 1;
    for (i = 0; i < 104; i++)
      work.s[i] = -z[i] + alpha;
  }
  /* Now initialize z. */
  /* Now must have alpha > max(-z). */
  alpha = -1e99;
  for (i = 0; i < 104; i++)
    if (alpha < -z[i])
      alpha = -z[i];
  if (alpha < 0) {
    for (i = 0; i < 104; i++)
      work.z[i] = z[i];
  } else {
    alpha += 1;
    for (i = 0; i < 104; i++)
      work.z[i] = z[i] + alpha;
  }
}
void fillrhs_start(void) {
  /* Fill rhs with (-q, 0, h, b). */
  int i;
  double *r1, *r2, *r3, *r4;
  r1 = work.rhs;
  r2 = work.rhs + 116;
  r3 = work.rhs + 220;
  r4 = work.rhs + 324;
  for (i = 0; i < 116; i++)
    r1[i] = -work.q[i];
  for (i = 0; i < 104; i++)
    r2[i] = 0;
  for (i = 0; i < 104; i++)
    r3[i] = work.h[i];
  for (i = 0; i < 32; i++)
    r4[i] = work.b[i];
}
long solve(void) {
  int i;
  int iter;
  double *dx, *ds, *dy, *dz;
  double minval;
  double alpha;
  work.converged = 0;
  setup_pointers();
  pre_ops();
#ifndef ZERO_LIBRARY_MODE
  if (settings.verbose)
    printf("iter     objv        gap       |Ax-b|    |Gx+s-h|    step\n");
#endif
  fillq();
  fillh();
  fillb();
  if (settings.better_start)
    better_start();
  else
    set_start();
  for (iter = 0; iter < settings.max_iters; iter++) {
    for (i = 0; i < 104; i++) {
      work.s_inv[i] = 1.0 / work.s[i];
      work.s_inv_z[i] = work.s_inv[i]*work.z[i];
    }
    work.block_33[0] = 0;
    fill_KKT();
    ldl_factor();
    /* Affine scaling directions. */
    fillrhs_aff();
    ldl_solve(work.rhs, work.lhs_aff);
    refine(work.rhs, work.lhs_aff);
    /* Centering plus corrector directions. */
    fillrhs_cc();
    ldl_solve(work.rhs, work.lhs_cc);
    refine(work.rhs, work.lhs_cc);
    /* Add the two together and store in aff. */
    for (i = 0; i < 356; i++)
      work.lhs_aff[i] += work.lhs_cc[i];
    /* Rename aff to reflect its new meaning. */
    dx = work.lhs_aff;
    ds = work.lhs_aff + 116;
    dz = work.lhs_aff + 220;
    dy = work.lhs_aff + 324;
    /* Find min(min(ds./s), min(dz./z)). */
    minval = 0;
    for (i = 0; i < 104; i++)
      if (ds[i] < minval*work.s[i])
        minval = ds[i]/work.s[i];
    for (i = 0; i < 104; i++)
      if (dz[i] < minval*work.z[i])
        minval = dz[i]/work.z[i];
    /* Find alpha. */
    if (-0.99 < minval)
      alpha = 1;
    else
      alpha = -0.99/minval;
    /* Update the primal and dual variables. */
    for (i = 0; i < 116; i++)
      work.x[i] += alpha*dx[i];
    for (i = 0; i < 104; i++)
      work.s[i] += alpha*ds[i];
    for (i = 0; i < 104; i++)
      work.z[i] += alpha*dz[i];
    for (i = 0; i < 32; i++)
      work.y[i] += alpha*dy[i];
    work.gap = eval_gap();
    work.eq_resid_squared = calc_eq_resid_squared();
    work.ineq_resid_squared = calc_ineq_resid_squared();
#ifndef ZERO_LIBRARY_MODE
    if (settings.verbose) {
      work.optval = eval_objv();
      printf("%3d   %10.3e  %9.2e  %9.2e  %9.2e  % 6.4f\n",
          iter+1, work.optval, work.gap, sqrt(work.eq_resid_squared),
          sqrt(work.ineq_resid_squared), alpha);
    }
#endif
    /* Test termination conditions. Requires optimality, and satisfied */
    /* constraints. */
    if (   (work.gap < settings.eps)
        && (work.eq_resid_squared <= settings.resid_tol*settings.resid_tol)
        && (work.ineq_resid_squared <= settings.resid_tol*settings.resid_tol)
       ) {
      work.converged = 1;
      work.optval = eval_objv();
      return iter+1;
    }
  }
  return iter;
}
