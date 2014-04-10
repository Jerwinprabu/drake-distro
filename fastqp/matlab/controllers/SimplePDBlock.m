classdef SimplePDBlock < MIMODrakeSystem
  % outputs a desired q_ddot (including floating dofs)
  properties
    nq;
    Kp;
    Kd;
    dt;
    controller_data; % pointer to shared data handle containing qtraj
    robot;
  end
  
  methods
    function obj = SimplePDBlock(r,controller_data,options)
      typecheck(r,'Atlas');
      typecheck(controller_data,'SharedDataHandle');
      
      coords = AtlasCoordinates(r);
      input_frame = MultiCoordinateFrame({coords,r.getStateFrame});
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
        obj.Kp = 170.0*eye(obj.nq);
%        obj.Kp([1,2,6],[1,2,6]) = zeros(3); % ignore x,y,yaw
      end        
        
      if isfield(options,'Kd')
        typecheck(options.Kd,'double');
        sizecheck(options.Kd,[obj.nq obj.nq]);
        obj.Kd = options.Kd;
      else
        obj.Kd = 19.0*eye(obj.nq);
 %       obj.Kd([1,2,6],[1,2,6]) = zeros(3); % ignore x,y,yaw
      end
      
      if isfield(options,'soft_ankles')
        typecheck(options.soft_ankles,'logical');
        if options.soft_ankles
          state_names = r.getStateFrame.coordinates(1:getNumDOF(r));
          lax_idx = find(~cellfun(@isempty,strfind(state_names,'lax')));
          uay_idx = find(~cellfun(@isempty,strfind(state_names,'uay')));
          obj.Kp(uay_idx,uay_idx) = 5*eye(2);
          obj.Kp(lax_idx,lax_idx) = 5*eye(2);
          obj.Kd(uay_idx,uay_idx) = 0.01*eye(2);
          obj.Kd(lax_idx,lax_idx) = 0.01*eye(2);
        end
      end
      
      if isfield(options,'dt')
        typecheck(options.dt,'double');
        sizecheck(options.dt,[1 1]);
        obj.dt = options.dt;
      else
        obj.dt = 0.003;
      end
      
      obj.robot = r;
      
      obj = setSampleTime(obj,[obj.dt;0]); % sets controller update rate
    end
   
    function y=mimoOutput(obj,t,~,varargin)
      q_des = varargin{1};
      x = varargin{2};
      q = x(1:obj.nq);
      qd = x(obj.nq+1:end);
      
			err_q = [q_des(1:3)-q(1:3);angleDiff(q(4:end),q_des(4:end))];
      y = max(-100*ones(obj.nq,1),min(100*ones(obj.nq,1),obj.Kp*err_q - obj.Kd*qd));
    end
  end
  
end
