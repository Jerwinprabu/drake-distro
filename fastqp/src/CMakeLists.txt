add_mex(QPControllermex QPControllermex.cpp)
pods_use_pkg_config_packages(QPControllermex eigen3 gurobi drake-qp drake-rbm)
set_target_properties(QPControllermex PROPERTIES COMPILE_FLAGS "-std=c++0x")
install(TARGETS QPControllermex DESTINATION matlab)
