*******************************
Atlas QP-based walking control
*******************************

Introduction
===============
This example code is meant to accompany the publication:

Scott Kuindersma, Frank Permenter, and Russ Tedrake. An Efficiently Solvable Quadratic Program for Stabilizing Dynamic Locomotion. In *Proceedings of the International Conference on Robotics and Automation (ICRA)*, Hong Kong, China, May 2014.

http://people.csail.mit.edu/scottk/papers/icra14/


Instructions
===============

This software requires Drake, Gurobi, and Matlab.

Get Gurobi
^^^^^^^^^^
- go to http://www.gurobi.com/
- download gurobi5.5.0_linux64.tar.gz and obtain a trial or free academic license

Get Drake
^^^^^^^^^
- git clone https://github.com/RobotLocomotion/drake-distro.git
- cd drake-distro
- git checkout rigidbody
- git submodule update --init --recursive
- copy gurobi5.5.0_linux64.tar.gz to gurobi folder
- make

Install QP walking code
^^^^^^^^^^^^^^^^^^^^^^^
- export PKG_CONFIG_PATH=/path/to/drake-distro/build/lib/pkgconfig:$PKG_CONFIG_PATH
- export LD_LIBRARY_PATH=/path/to/drake-distro/build/lib:$LD_LIBRARY_PATH
- git clone https://github.com/kuindersma/qp-walking.git
- cd qp-walking
- make

In matlab, run

- addpath('/path/to/drake-distro/build/matlab/')
- addpath_fastqp
- cd matlab/test
- drakeWalking