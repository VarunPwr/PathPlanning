classdef manipulator_domain < handle   
  properties
      domain;
      orientation;
      initial_pos1;
      initial_pos2;
  end    
  methods
        function plot3d(obj)
          point = obj.domain;
          figure
          plot3(point(:,1), point(:,2), point(:,3),'.');
        end
        function IRsensor(obj)
            if length(obj.orientation) == 7
                lorientation = obj.orientation(5:7);
            end
            sz = size(obj.domain);
            dist = sqrt((obj.domain(:,1) - lorientation(1)).^2 + (obj.domain(:,2) - lorientation(2)).^2 + (obj.domain(:,3) - lorientation(3)).^2)  ;
            for i = 1 : sz(1)
                if feasible_domain_mp([obj.domain(i,1) obj.domain(i,2) obj.domain(i,3)]) == -1 && dist(i) <= 1
                %above condition dist_i < 0.3 is the IR bound for the
                %robot
                obj.domain(i,4) = -1;
                %     elseif dist_i(count) > 0.3
                end
            end
        end    
%         function f = feasible_edge_mp(obj)
%             x_initial = obj.initial_pos1;
%             x_final = obj.initial_pos2;
%             [theta1,rho1,z1] = cart2pol(x_initial(1),x_initial(2),x_initial(3));
%             [theta2,rho2,z2] = cart2pol(x_final(1),x_final(2),x_final(3));
%             pos1 = [rho1 theta1 z1];
%             pos2 = [rho2 theta2 z2];
%             %presence of obstacle given by inertial sensor
%             %pos1 and pos2 is in radial basis
%             sol_space1 = space_manip_map(pos1,-1);
%             %not a solution but the solution space
%             sol_space2 = space_manip_map(pos2,-1);
%             % clear i j cost_theta cost_phi cost sol_space1 sol_space2
%             %first element is d,second is theta and third is phi
%             %actual motion dynamics is handled by this function so it is safe to
%             %introduce three dualquaternion operators for the prismatic and revolutet
%             %joints
%             %following is from the paper
%             %R1 for phi based revolute joint R2 for theta based revolute joint and R3
%             %for prisamtic joint
%             %first operate R3
% 
%             cost = [];
%             for i = 1 : 2
%                 for j = 1 : 2
%                     cost = vertcat(cost, abs(sol_space1(i,2) - sol_space2(j,2)) + abs(sol_space1(i,3) - sol_space2(j,3)));
%                 end
%             end
% 
%             % cost = [];
%             % for i =1 :4
%             %     for j =1:4
%             %         cost = vertcat(cost,cost_theta(i) + cost_phi(j));
%             %     end
%             % end
%             %remember quaternion is a useless quantity of the spce it doesnot provide
%             %any information about the orientatin just the commulative angle traversed.
%             %indx is like x then y
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             [~,indx] = min(cost);
%             %redifine i and j for cost_theta and cost_phi respectively
%             %i = (indx-1)mod4 + 1;j = (indx-1)%4
%             %j = indx(1) && i = indx(2) so floor((j-1)/2)for solspace1 and rem(j-1,2)for solspace2
%             %for both i and j i-1 mod 2  +1 and i-1%2 +1 is indx of sol1 and sol2
%             %respectively
%             i = floor((indx-1)/2) +1 ;
%             j = rem(indx-1,2) +1 ;
%             sol1 = [sol_space1(1,1),sol_space1(i,2),sol_space1(i,3)];
%             sol2 = [sol_space2(1,1),sol_space2(j,2),sol_space2(j,3)];%%both solutions placed
%             obj.orientation = dualquatmultiply(R1(sol1(3)),dualquatmultiply(R2(sol1(2)),R3(sol1(1))))%%operator is working fine
%             manipulator_domain.IRsensor;
%             chk =1;
%             %figure
%             for i = 0 : 0.01 : 1
%             obj.orientation = dualquatmultiply(R3((sol2(1) - sol1(1))*0.01),obj.orientation);%%first all prismatic motion is enabled
%             pos = [sol1(1)*(1-i) + sol2(1)*i,sol1(2:3)];
%             if mainpulator_chk(pos) == -1
%             chk = -1;
%             break;
%             else
%             continue;
%             end
%             %chk feasibililty of all arms 
%             end
%             %%%%%%%%%%%%%
%             %make sure that the vector rotation also includes the translation 
%             if chk == 1 
%             for i = 0 : 0.01 : 1 
%             obj.orientation = dualquatmultiply(R1(sol1(3)),dualquatmultiply(R2(sol1(2)*(1-i) + sol2(2)*i),R3(sol2(1))));%%first all prismatic motion is enabled
%             pos = [sol2(1),sol1(2)*(1-i) + sol2(2)*i,sol1(3)];
%             if mainpulator_chk(pos) == -1
%                chk = -1;
%                break;
%             else
%                 continue;
%             end
%             %chk feasibililty of all arms 
%             end%%first all prismatic motion is enabled
%             end
%             %%%%%%%%%%%%%
%             if chk == 1
%             for i = 0 : 0.01 : 1
%             obj.orientation = dualquatmultiply(R1(sol1(3)*(1-i) + sol2(3)*i),dualquatmultiply(R2(sol2(2)),R3(sol2(1))));%%first all prismatic motion is enabled
%             pos = [sol2(1),sol2(2),sol1(3)*(1-i) + sol2(3)*i];
%             if mainpulator_chk(pos) == -1
%                chk = -1;
%                break;
%             else
%                 continue;
%             end
% 
%             %chk feasibility of all arms
%             end
%             end
%             if chk == -1
%             f = obj.orientation(5:7);
%             else
%             f = x_final;
%             end
%         end

  end
end
