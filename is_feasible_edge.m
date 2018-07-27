% function f = is_feasible_edge(x_initial,x_final,robot)
% narginchk(2,3)
% 
% 
% if isempty(robot.edge_domain) == 1 || nargin == 2
%     ind = [];
% else 
% %     indx = find(robot.domain(:,1) == x_initial(1));
% %     indy = find(robot.domain(:,2) == x_initial(2));
% %     ind1 = intersect(indx,indy)
%          ind1 = search_point_domain(x_initial,robot);
%          if isempty(ind1) == 1
%           robot.domain = vertcat(robot.domain, [x_initial 1 1 1]);
%           ind1 = length(robot.domain) ;
%          end
% %     indx = find(robot.domain(:,1) == x_final(1));
% %     indy = find(robot.domain(:,2) == x_final(2));
% %     ind2 = intersect(indx,indy)
% 	    ind2 = search_point_domain(x_final,robot);
%         if isempty(ind2) == 1
%             robot.domain = vertcat(robot.domain,[x_final 1 1 1]); %%make sure if this is infeasilbe is changed
%             ind2 = length(robot.domain);
%         end
%     indx = find(robot.edge_domain(:,1) == ind1);
%     indy = find(robot.edge_domain(:,2) == ind2);
%     ind = intersect(indx,indy);
%     clear indx indy;
%     
% end
% if isempty(ind) == 1
%     sz = size(x_initial);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     for t = 0 : 0.001 : 1 %steps associated with the robot consider here a 3 d robot
%         x = (1-t) * x_initial + (t) * x_final;
%         if is_feasible_point(x') == 0 
%             break;
%         end
%         %associated array is horizontal one
%     end
% %     t = t - 0.001;
%     x = (1-t) * x_initial + (t) * x_final;
%     if nargin == 3
% %         indx = find(robot.domain(:,1) == x_initial(1));
% %         indy = find(robot.domain(:,2) == x_initial(2));
% %         ind1 = intersect(indx,indy);
%         ind1 = search_point_domain(x_initial,robot);
%         if isempty(ind1) == 1
%             robot.domain = vertcat(robot.domain, [x_initial 1 1 1]);
%             ind1 = length(robot.domain) ;
%         end
%           %%change this later
%        
% % 
% %         indx = find(robot.domain(:,1) == x_final(1));
% %         indy = find(robot.domain(:,2) == x_final(2));
% %         ind2 = intersect(indx,indy);
%         ind2= search_point_domain(x_final,robot);
%         if isempty(ind2) == 1
%           robot.domain = vertcat(robot.domain, [x_final 1 1 1]);
%           ind2 = length(robot.domain) ;
%         end
% %         
% %         indx = find(robot.domain(:,1) == x(1));
% %         indy = find(robot.domain(:,2) == x(2));
% %         ind_pos = intersect(indx,indy);
%         
%         if round(abs(x_final - x),3) == 0
%             ind_pos = ind2;
%         else
%             robot.domain(ind2,3) = 0;
%             ind_pos = search_point_domain(x,robot);
%             if isempty(ind_pos) == 1
%                 robot.domain = vertcat(robot.domain,[x(1) x(2) 1 1 1]);
%                 ind_pos = length(robot.domain);
%             end
%         end 
%         robot.edge_domain = vertcat(robot.edge_domain,[ind1 ind2 ind_pos]);
%     end
%     f = [x ind_pos];    
%     %f = t;
%     clear t;
% else
%    
%    final_indx = robot.edge_domain(ind,3);
%    f = [robot.domain(final_indx,1:2) final_indx];
% 
%     %purpose of this check is to find the feasiblility of check
% end
% end
% function f = search_point_domain(x,robot)
%     indx = find(robot.domain(:,1) == x(1));
%     indy = find(robot.domain(:,2) == x(2));
%     ind1 = intersect(indx,indy);
%     f = ind1;
% end



function f = is_feasible_edge(node1, node2, robot)
%it decides the motion of robot from node 1 to 2
if length(node1) == 1
    x_initial = robot.domain(node1,1:2);
else
    x_initial = node1;
end
x_final = robot.domain(node2,1:2); 
cost = 0;%cost is just a notation
for t = 0 : 0.001 : 1 %steps associated with the robot consider here a 3 d robot
    x = (1-t) * x_initial + (t) * x_final;
    if is_feasible_point(x') == 0     
        cost = 1;
        break;
    else
        robot.current_pos = x;
    end
%associated array is horizontal one
end
if cost == 1
    f = inf;
else
    f = 0;%success
end
end
