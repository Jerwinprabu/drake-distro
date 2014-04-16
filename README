

*******************************
Atlas QP-based walking control
*******************************

Introduction
===============
This branch of drake-distro is meant for sharing code that accompanies the publication:

Scott Kuindersma, Frank Permenter, and Russ Tedrake. An Efficiently Solvable Quadratic Program for Stabilizing Dynamic Locomotion. In *Proceedings of the International Conference on Robotics and Automation (ICRA)*, Hong Kong, China, May 2014.

http://people.csail.mit.edu/scottk/papers/icra14/

As such, it will not be maintained to work with future versions of drake. If you're looking for the very latest code, go to: https://github.com/RobotLocomotion/drake-distro

Instructions
===============


Prerequisite: create a Gurobi account
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- go to http://www.gurobi.com/ and create an account

Step-by-step
^^^^^^^^^^^^
- git clone https://github.com/kuindersma/drake-distro.git
- cd drake-distro
- git checkout qp-walking
- git submodule update --init --recursive
- make

When prompted to enter your gurobi.com username and password, please do so. 


Install QP walking code
^^^^^^^^^^^^^^^^^^^^^^^
- export PKG_CONFIG_PATH=/path/to/drake-distro/build/lib/pkgconfig:$PKG_CONFIG_PATH
- export LD_LIBRARY_PATH=/path/to/drake-distro/build/lib:$LD_LIBRARY_PATH
- git clone https://github.com/kuindersma/qp-walking.git
- cd qp-walking
- make
- cd fastqp

In matlab, run

- addpath('/path/to/drake-distro/build/matlab/')
- addpath_fastqp
- cd matlab/test
- drakeWalking

