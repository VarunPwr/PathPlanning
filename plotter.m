%%plotter is an extensive function checker 
%assume is_feasible_point is correct by-default

% 1 . is _feasible_edge 

% tic;
% t = 100*rand(10000,2);
% indf=[];
% for i = 1 : length(t)
%     chk = is_feasible_point([ t(i,1) t(i,2)]);
%     if chk == 1
%         indf = vertcat(indf, i);
%     end
% end
% plot(t(indf,1),t(indf,2),'.g');
% hold on
% 
% a = 0;
% b = 100;
% x_domain = (b-a).*rand(300,1) + a;
% y_domain = (b-a).*rand(300,1) + a;
% label = ones(300,1);
% count = zeros(300,1);
% repeat = zeros(300,1);
% robot = robot_domain;
% robot.domain = [x_domain y_domain label count repeat];
% clear x_domain y_domain label count repaet;
% robot.initial_pos1 = [0 0];
% robot.initial_pos2 = [12 78];
% x_alt = is_feasible_edge(robot.initial_pos1,robot.initial_pos2,robot);
% plot([robot.initial_pos1(1),robot.initial_pos2(1)],[robot.initial_pos1(2),robot.initial_pos2(2)],'ok');
% hold on
% plot([robot.initial_pos1(1),robot.initial_pos2(1)],[robot.initial_pos1(2),robot.initial_pos2(2)],'-b');
% hold on
% plot(x_alt(1),x_alt(2),'or')
% toc;

% 2. Hlearning CHEKCED!!
clear;
close;
tic
a = 0;
b = 100;
x_domain = (b-a).*rand(300,1) + a;
y_domain = (b-a).*rand(300,1) + a;
label = ones(300,1);
count = zeros(300,1);
repeat = zeros(300,1);
robot = robot_domain;
robot.cost = Inf(300,1);
t = 100*rand(10000,2);
for i = 1 : length(t)
    chk = is_feasible_point([ t(i,1) t(i,2)]);
    if chk == 0
        robot.obstacle = vertcat(robot.obstacle, [ t(i,1) t(i,2)]);
    end
end
hold on

robot.domain = [x_domain y_domain label count repeat];
clear x_domain y_domain label count repeat;
robot.current_pos = [0 0];
dest_pos_d = (b-a).*rand(400,2) + a;
% % for i = 1 : 400
%     close all
path_ind = Hlearning( robot);
%     robot.domain(pth_ind,1:2)
% end
% plot(robot.domain(:,1),robot.domain(:,2),'or');
% hold on
% plot(robot.domain(path_ind(:),1),robot.domain(path_ind(:),2),'ok');
% hold on
% plot(robot.domain(path_ind,1),robot.domain(path_ind,2),'-b');
toc;

% 3. IR sensor

% tic;
% 
% a = 0;
% b = 100;
% x_domain = (b-a).*rand(10000,1) + a;
% y_domain = (b-a).*rand(10000,1) + a;
% label = ones(10000,1);
% count = zeros(10000,1);
% repeat = zeros(10000,1);
% robot = robot_domain;
% robot.domain = [x_domain y_domain label count repeat];
% clear x_domain y_domain label count repaet;
% robot.current_pos = [0 0];
% dest_pos = [98 78];
% path_ind = robot.IRsensor
% figure
% % plot(robot.domain(:,1),robot.domain(:,2),'or');
% % hold on
% % plot(robot.domain(path_ind,1),robot.domain(path_ind,2),'ok');
% % hold on
% plot(robot.domain(path_ind,1),robot.domain(path_ind,2),'o');
% toc;
