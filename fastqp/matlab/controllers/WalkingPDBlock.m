classdef WalkingPDBlock < MIMODrakeSystem
  % outputs a desired q_ddot (including floating dofs)
  properties
    nq;
    Kp;
    Kd;
    dt;
    controller_data; % pointer to shared data handle containing qtraj
    ikoptions;
    robot;
    max_nrm_err;
    contact_est_monitor;
    l_ank;
    r_ank;
    ik_qnom;
  end
  
  methods
    function obj = WalkingPDBlock(r,controller_data,options)
      typecheck(r,'Atlas');
      typecheck(controller_data,'SharedDataHandle');
            
      input_frame = MultiCoordinateFrame({AtlasCoordinates(r),r.getStateFrame});
      coords = AtlasCoordinates(r);
      obj = obj@MIMODrakeSystem(0,0,input_frame,coords,true,true);
      obj = setInputFrame(obj,input_frame);
      obj = setOutputFrame(obj,coords);

      obj.controller_data = controller_data;
      obj.nq = getNumDOF(r);

      if nargin<3
        options = struct();
      end
      
      if isfield(options,'Kp')
        typecheck(options.Kp,'double');
        sizecheck(options.Kp,[obj.nq obj.nq]);
        obj.Kp = options.Kp;
      else
        obj.Kp = 160.0*eye(obj.nq);
        %obj.Kp(1:2,1:2) = zeros(2); % ignore x,y
        %obj.Kp(19:20,19:20) = 75*eye(2); % make left/right ankle joints softer
        %obj.Kp(31:32,31:32) = 75*eye(2);
      end        
        
      if isfield(options,'Kd')
        typecheck(options.Kd,'double');
        sizecheck(options.Kd,[obj.nq obj.nq]);
        obj.Kd = options.Kd;
      else
        obj.Kd = 19.0*eye(obj.nq);
        %obj.Kd(1:2,1:2) = zeros(2); % ignore x,y
        %obj.Kd(19:20,19:20) = 10*eye(2); % make left/right ankle joints softer
        %obj.Kd(31:32,31:32) = 10*eye(2);
      end        
        
      if isfield(options,'dt')
        typecheck(options.dt,'double');
        sizecheck(options.dt,[1 1]);
        obj.dt = options.dt;
      else
        obj.dt = 0.004;
      end
     
      state_names = r.getStateFrame.coordinates(1:getNumDOF(r));
      obj.l_ank = find(~cellfun(@isempty,strfind(state_names,'l_leg_akx')) | ~cellfun(@isempty,strfind(state_names,'l_leg_aky')));
      obj.r_ank = find(~cellfun(@isempty,strfind(state_names,'r_leg_akx')) | ~cellfun(@isempty,strfind(state_names,'r_leg_aky')));
      
      if isfield(options,'q_nom')
        typecheck(options.q_nom,'double');
        sizecheck(options.q_nom,[obj.nq 1]);
        q_nom = options.q_nom;
        obj.controller_data.setField('qtraj',q_nom);
      else
        d = load('../data/atlas_fp.mat');
        q_nom = d.xstar(1:obj.nq);
        obj.controller_data.setField('qtraj',q_nom);
      end
      
      if ~isfield(obj.controller_data,'trans_drift')
        obj.controller_data.setField('trans_drift',[0;0;0]);
      end
      
      % setup IK parameters
      cost = Point(r.getStateFrame,1);
      cost.base_x = 0;
      cost.base_y = 0;
      cost.base_z = 0;
      cost.base_roll = 1000;
      cost.base_pitch = 1000;
      cost.base_yaw = 0;
      cost.back_bkz = 10;
      cost.back_bky = 100;
      cost.back_bkx = 100;

      cost = double(cost);
      
%      arm_idx = find(~cellfun(@isempty,strfind(state_names,'arm')));
%      cost(arm_idx) = 0.1*ones(length(arm_idx),1);
      obj.ikoptions = IKoptions(r);
      obj.ikoptions = obj.ikoptions.setQ(diag(cost(1:obj.nq)));
      obj.ik_qnom = q_nom;
      % Prevent the knee from locking
      %[obj.ikoptions.jointLimitMin, obj.ikoptions.jointLimitMax] = r.getJointLimits();
      %joint_names = r.getStateFrame.coordinates(1:r.getNumDOF());
      %obj.ikoptions.jointLimitMin(~cellfun(@isempty,strfind(joint_names,'kny'))) = 0.6;

      obj = setSampleTime(obj,[obj.dt;0]); % sets controller update rate

      obj.robot = r;
      obj.max_nrm_err = 1.5;
            
    end
   
    function y=mimoOutput(obj,t,~,varargin)
      x = varargin{2};
      q = x(1:obj.nq);
      qd = x(obj.nq+1:end);

      obj.ik_qnom = varargin{1};
      cdata = obj.controller_data.data;
      
      approx_args = {};
      for j = 1:length(cdata.link_constraints)
        if ~isempty(cdata.link_constraints(j).traj)
          pos = fasteval(cdata.link_constraints(j).traj,t);
%           pos(3) = pos(3) - cdata.trans_drift(3);
          pos(1:3) = pos(1:3) - cdata.trans_drift;
%           approx_args_bk(end+1:end+3) = {cdata.link_constraints(j).link_ndx, cdata.link_constraints(j).pt, pos};
          approx_args = [approx_args,{constructRigidBodyConstraint(RigidBodyConstraint.WorldPositionConstraintType,true,...
            obj.robot,cdata.link_constraints(j).link_ndx,cdata.link_constraints(j).pt,pos(1:3,:),pos(1:3)),...
            constructRigidBodyConstraint(RigidBodyConstraint.WorldEulerConstraintType,true,obj.robot,...
            cdata.link_constraints(j).link_ndx,pos(4:6,1),pos(4:6,1))}];
        else
          pos_min = fasteval(cdata.link_constraints(j).min_traj,t);
%           pos_min(3) = pos_min(3) - cdata.trans_drift(3);
          pos_min(1:3) = pos_min(1:3) - cdata.trans_drift;
          pos_max = fasteval(cdata.link_constraints(j).max_traj,t);
%           pos_max(3) = pos_max(3) - cdata.trans_drift(3);
          pos_max(1:3) = pos_max(1:3) - cdata.trans_drift;
%           approx_args_bk(end+1:end+3) = {cdata.link_constraints(j).link_ndx, cdata.link_constraints(j).pt, struct('min', pos_min, 'max', pos_max)};
          approx_args = [approx_args,{constructRigidBodyConstraint(RigidBodyConstraint.WorldPositionConstraintType,true,...
            obj.robot,cdata.link_constraints(j).link_ndx,cdata.link_constraints(j).pt,pos_min(1:3,:),pos_max(1:3)),...
            constructRigidBodyConstraint(RigidBodyConstraint.WorldEulerConstraintType,true,obj.robot,...
            cdata.link_constraints(j).link_ndx,pos_min(4:6,1),pos_max(4:6,1))}];
        end
      end
      
      % note: we should really only try to control COM position when in
      % contact with the environment
      com = fasteval(cdata.comtraj,t);
      if length(com)==3
        compos = [com(1:2) - cdata.trans_drift(1:2);com(3)];
      else
        compos = [com(1:2) - cdata.trans_drift(1:2);nan];
      end
      kc_com = constructRigidBodyConstraint(RigidBodyConstraint.WorldCoMConstraintType,true,obj.robot,compos,compos);
      approx_args = [approx_args,{kc_com}];
      [q_des,info] = approximateIKmex(obj.robot.getMexModelPtr,q,obj.ik_qnom,approx_args{:},obj.ikoptions.mex_ptr);

      err_q = q_des - q;
      nrmerr = norm(err_q,1);
      if nrmerr > obj.max_nrm_err
        err_q = obj.max_nrm_err * err_q / nrmerr;
      end
      y = max(-100*ones(obj.nq,1),min(100*ones(obj.nq,1),obj.Kp*err_q - obj.Kd*qd));
    end
  end
  
end
