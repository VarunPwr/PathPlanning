tic;
clear;close;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('hi');
a = 0;
b = 100;
x_domain = (b-a).*rand(300,1) + a;
y_domain = (b-a).*rand(300,1) + a;
label = ones(300,1);
count = zeros(300,1);
robot = robot_domain;
robot.domain = [x_domain y_domain label count];
x_domain = [];
y_domain = [];
count = [];
figure
plot(robot.domain(:,1),robot.domain(:,2),'.')
title('Nodes generated before search');
global feasible_domain;
feasible_domain = [];
global infeasible_domain;
infeasible_domain = [];
%%%%
x = 0;%%defined first point as 0,0  which is feasible and last point as random x_2
y = 0;
x_2 = (b-a).*rand(1,1) + a;
y_2 = (b-a).*rand(1,1) + a;
% figure
% t = test_plot(2);
% plot(t(:,1),t(:,2),'.y')
% hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 for i =1 : 5000
% while size(domain) ~= size(feasible_domain) - count 
    dist_prev =10000;
    pos = [];
    while x ~= x_2 && y ~= y_2 
        if is_feasible_point([x y],robot) == 1 %a dynamic step for moving from feasible previously to x,y
%             feasible_domain = vertcat(feasible_domain, [x y ]) ;%cell typpe for svm
            indx = find(robot.domain(:,1) == x);
            indy = find(robot.domain(:,2) == y);
            ind_pos = intersect(indx,indy);
            if isempty(ind_pos) == 1
                robot.domain = vertcat(robot.domain,[x y 1 0]);
                ind_pos = length(robot.domain);
            else
                robot.domain(ind_pos,3) = 1;
            end
            clear indx indy;
            dist_i = sqrt((robot.domain(:,1) - x).^2 + (robot.domain(:,2) - y).^2);
            dist_f = sqrt((robot.domain(:,1) - x_2).^2 + (robot.domain(:,2) - y_2).^2)  ;
            dist = dist_i+dist_f;
            count = 1;
            sz = size(dist);
            while sz(1) ~= count
                if is_feasible_point([robot.domain(count,1) robot.domain(count,2)],robot) == 0 && dist_i(count) <= 0.3
                    %above condition dist_i < 0.3 is the IR bound for the
                    %robot
%                     infeasible_domain = vertcat(infeasible_domain, [domain(count,1) domain(count,2)]);
% %                     dist(count) = [];
%                     dist_i(count) = [];
%                     dist_f(count) = [];
%                     domain(count,:) = [];
                    robot.domain(count,3) = 0;
                end
                count = count +1;
%                 sz = [];
%                 sz = size(dist);
            end
            [val pos] = min(dist);
            while dist_i(pos) >= 0.3 && robot.domain(pos,1) == x && robot.domain(pos,2) == y || robot.domain(pos,4) == 1
%this step is very important dis_i(pos) >= dist_f(pos) suggest that the
%robt should follow nodes  such that it should be halfway from the destined
%node / it could be compensated for dist_i(pos) >= ir bound so that robot
%will only travel the visible nodes(dead reckoning)
                dist(pos) = 10000000;
                [val pos] = min(dist);
            end    
            if dist_prev > dist_f(pos)
                x = robot.domain(pos,1);
                y = robot.domain(pos,2);
                robot.domain(pos,4) = 1;  
                dist_prev = dist_f(pos)
            else
                x = x_2;
                y = y_2;
                break;
            end
            dist_i = [];
            dist_f = [];
            dist = [];
            
        else
%             indx = find(robot.domain(:,1) == x);
%             indy = find(robot.domain(:,2) == y);
%             ind = intersect(indx,indy);
%             if isempty(ind) == 1
%                 robot.domain = vertcat(robot.domain,[x y 0 0]);
%             else
%                 robot.domain(ind,3) = 0;
%             end
%             clear indx indy ind;
            indx = find(robot.domain(:,1) == x);
            indy = find(robot.domain(:,2) == y);
            ind_pos = intersect(indx,indy);
            if isempty(ind_pos) == 1
                robot.domain = vertcat(robot.domain,[x y 0 0]);
                ind_pos = length(robot.domain);
            else
                robot.domain(ind_pos,3) = 0;
                
            end
            t = is_feasible_edge(robot.domain(ind_pos,1:2),[x y],robot);%% I am here
            x = t(1);
            y = t(2);
            clear t;
            break;
        end   
    end
    robot.domain(:,4) = 0;
    x_2 = (b-a).*rand(1,1) + a;
    y_2 = (b-a).*rand(1,1) + a;
%     plot(feasible_domain(:,1),feasible_domain(:,2),'og')
%     if isnan(infeasible_domain) == 0
%         hold on
%         plot(infeasible_domain(:,1),infeasible_domain(:,2),'or')
%     end
%     pause(0.005)
%     hold on
 end
%  hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
dist = [];
dist_i = [];
dist_f = [];
a = [];
b = [];
i = [];
x = [];
y = [];
x_2 = [];
y_2 = [];
val = [];
dist_prev = [];
count = [];
sz = [];
pos = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
domain = [];
% domain = vertcat(feasible_domain,infeasible_domain);
% tri = delaunay(domain(:,1),domain(:,2));
% i = 1;
% while i ~= length(tri)
%     vert1 = tri(i,1);
%     vert2 = tri(i,2);
%     vert3 = tri(i,3);
%     con1 = is_feasible_edge(domain(vert1,1:2),domain(vert2,1:2)) ;
%     con2 = is_feasible_edge(domain(vert2,1:2),domain(vert3,1:2)) ;
%     con3 = is_feasible_edge(domain(vert3,1:2),domain(vert1,1:2)) ;
%     i = 1 + i;
% end
% trimesh(tri,domain(:,1),domain(:,2));
% hold off;

toc

figure
t = test_plot(2);
plot(t(:,1),t(:,2),'.y');
hold on 
indf = find(robot.domain(:,3) == 1);
plot(robot.domain(indf,1),robot.domain(indf,2),'og');
indif = find(robot.domain(:,3) == 0);
plot(robot.domain(indif,1),robot.domain(indif,2),'or');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Following is a more appropriate method as far as I believe, just
% %% comment if the below one didn't work
% tic;
% clear;close;
% global domain; 
% % [ domain, triang_index] = 
% initialize_domain();
toc;
