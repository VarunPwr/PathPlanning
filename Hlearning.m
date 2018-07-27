% function f = Hlearning(dest_node, robot)
% path_ind = [];
% dist_prev = inf;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% tic;
% t = 100*rand(10000,2);
% indf=[];
% for i = 1 : length(t)
%     chk = is_feasible_point([ t(i,1) t(i,2)]);
%     if chk == 0
%         indf = vertcat(indf, i);
%     end
% end
% plot(t(indf,1),t(indf,2),'.g');
% hold on
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% while dest_node(1) ~= robot.current_pos(1) && dest_node(2) ~= robot.current_pos(2)
% curr_pos = robot.current_pos;
% inf_ind = robot.IRsensor;
% rep_ind = find(robot.domain(inf_ind,5) == 1);%repeat in the query
% if isempty(rep_ind) == 0
%     inf_ind(rep_ind) = [];
%     clear rep_ind;
% end
% plot(robot.domain(inf_ind,1), robot.domain(inf_ind,2), 'o' );
% hold on
% plot(curr_pos(1),curr_pos(2), 'or' );
% xlim([0 100])
% ylim([0 100])
% % tri = delaunay([robot.domain(inf_ind,1);curr_pos(1)], [robot.domain(inf_ind,2);curr_pos(2)]);
% % hold on;
% % % triplot(tri,[robot.domain(inf_ind,1);curr_pos(1)], [robot.domain(inf_ind,2);curr_pos(2)]);
% % % hold off;
% dist =  sqrt((robot.domain(inf_ind,1) - curr_pos(1)).^2 + (robot.domain(inf_ind,2) - curr_pos(2)).^2) + sqrt((robot.domain(inf_ind,1) - dest_node(1)).^2 + (robot.domain(inf_ind,2) - dest_node(2)).^2);
% [~,pos] = min(dist);
% 
% next_pos = robot.domain(inf_ind(pos),1:2);
% dist_next = sqrt((next_pos(1) - dest_node(1)).^2 + (next_pos(2)- dest_node(2)).^2) ;
% 
% if dist_prev > dist_next
% hold on
% next_pos_t = is_feasible_edge(curr_pos, next_pos, robot);
% next_pos = next_pos_t(1:2);
% next_pos_ind = next_pos_t(3);
% plot([curr_pos(1) next_pos(1)],[curr_pos(2) next_pos(2)],'-g')
% pause(0.5)
% hold on 
% robot.domain(next_pos_ind,5) = 1;
% robot.domain(next_pos_ind,4) = 1 + robot.domain(next_pos_ind,4);
% robot.current_pos = next_pos;
% dist_prev = dist_next;
% else
% dest_node_t = is_feasible_edge(curr_pos, dest_node, robot);
% dest_node = dest_node_t(1:2);
% dest_node_ind = dest_node_t(3);    
% plot([curr_pos(1) dest_node(1)],[curr_pos(2) dest_node(2)],'-g')
% pause(0.5)
% hold on 
% robot.domain(dest_node_ind,5) = 1;
% robot.domain(dest_node_ind,4) = 1 + robot.domain(dest_node_ind,4);
% robot.current_pos = dest_node;
% plot(dest_node(1),dest_node(2),'or')
% break;   
% end
% end
% f = dest_node_ind;
% 
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%following is for triangulation based path planning algorithm

function f = Hlearning(robot)
%using delunay triangulation technique
tri_domain = delaunay(robot.domain(:,1),robot.domain(:,2));
tri_domain_b = [ tri_domain(:,2),tri_domain(:,3),tri_domain(:,1)];
robot.edge_domain = [ tri_domain(:) tri_domain_b(:) ];
% %repetition indx
rep_ind = repchk(robot.edge_domain);
robot.edge_domain(rep_ind,:) = [];
robot.edge_domain(:,3) = 1000000;
% The following is a simple version of D* algorithm
%D* algorithm uses three varibles h c b where h is heuristic c is the cost
%and b is the backfunction
est = 0;
tic
length_prev = 0;
while length(find(robot.edge_domain(:,3) == 1000000)) ~= 0 
% for i = 1 :10
int_nodes = random_nodes(2, robot);
start_node = int_nodes(1);
end_node = int_nodes(2);
prev_node = 0;
current_node = start_node;
robot.domain(current_node, 4) = 1;
robot.cost(start_node) = 0; %obnoxious
%expand has a same meaning as the one in D* alggorithm it
%just gives the neighbours.
% while start_node ~= end_node
 
path = current_node;
robot.domain(current_node, 5) = 1 + robot.domain(current_node, 5); 
while current_node ~= end_node
% clf
% plot(robot.obstacle(:,1),robot.obstacle(:,2),'.r');
% hold on
% plot([robot.domain(current_node,1) robot.domain(end_node,1)],[robot.domain(current_node,2) robot.domain(end_node,2)],'or')
% xlim([0 100])
% ylim([0 100])
% hold on

open = expand(current_node, robot.edge_domain);
% plot(robot.domain(open(:),1) ,robot.domain(open(:),2),'og')

hdomain = returnh(open,end_node,robot);%returns the distance betweeen nodes
cdomain = givecost(current_node, open, robot);
%total pursuit : doesn't stop for obstacle
fdomain = hdomain + cdomain;
indx = find(fdomain(:) == inf);
if isempty(indx) == 0
    open(indx) = [];
    fdomain(indx) = [];
end
store_in_cost(robot, open, fdomain); %not until the motion
next_node = move_forward(robot, open, current_node);
if next_node == 0
    break;
else
    if robot.domain(next_node, 4) == 1
        break;
    end
    prev_node = current_node;
    current_node = next_node;
end
robot.cost(prev_node) = inf;
robot.domain(current_node, 4) = 1;
robot.domain(current_node, 5) = 1 + robot.domain(current_node, 5); 
path = vertcat(path, current_node);
% plot([robot.domain(current_node, 1) robot.domain(prev_node ,1)],[robot.domain(current_node, 2) robot.domain(prev_node, 2)],'-b')
% pause(0.5)
% hold on
est =est +1;
end
robot.cost(:) = inf;
robot.domain(path(:), 4) = 0;
length_curr = length(find(robot.edge_domain(:,3) ~= 1000000))
X = abs(length_curr);
T = toc;
plot(T, X, 'or')
pause(0.0001)
hold on
end
f = 1;
% end
% %infeasiblity indx
% inf_ind = find(robot.domain(:,3) == 0);%infeasilble index
% inf_indx = infchk(edge_domain, inf_ind);
% edge_domain(inf_indx,:) = [];
% 
% 
% f = edge_domain;
% end
% 
% function f = search_indx(x,robot)
% indx = find(robot.domain(:,1) == x(1));
% indy = find(robot.domain(:,2) == x(2));
% ind = intersect(indx,indy);
% if isempty(ind)
%     f = 0;
% else 
%     f = ind;
% end
end
% 
function f = repchk(edge_domain)
tic;
ind = [];
for i = 1 : length(edge_domain) -1
    for j = i +1 : length(edge_domain)
        chk1 = abs(edge_domain(i,1) - edge_domain(j,1)) + abs(edge_domain(i,2) - edge_domain(j,2));
        chk2 = abs(edge_domain(i,1) - edge_domain(j,2)) + abs(edge_domain(i,2) - edge_domain(j,1));
        if chk1 == 0 || chk2 == 0
            ind = vertcat(ind,j);
        end
    end
end
toc;
f = ind; 
end
% 
% function f = infchk(edge_domain, inf_ind)
% tic;
% ind = [];
% for i = 1 : length(edge_domain)
%     indx = find(inf_ind == edge_domain(i,1));
%     indy = find(inf_ind == edge_domain(i,2));
%     if isempty(indx) == 0 || isempty(indy) == 0
%         ind = vertcat(ind,i);
%     end
% end
% toc;
% f = ind; 
% end
function f = random_nodes(n, robot)
sz = length(robot.domain);
r = randi([1 sz],1,sz);
rand =[];
count = 0 ;
i  = 1; 
while count ~= n && i ~= sz
    if is_feasible_point([robot.domain(r(i),1) robot.domain(r(i),2)],robot) == 1
        count = count + 1;
        rand = vertcat(rand, r(i));
    else
        robot.domain(r(i),3) = 0;
        open = expand(r(i), robot.edge_domain);
        current_node = r(i);
        for j = length(open)
            edge_pos = search_edge(open(j),current_node, robot);
            robot.edge_domain(edge_pos,3) = inf;
        end
        robot.domain(r(i),5) = 1 + robot.domain(r(i),5);
    end
    i = i + 1;
end
f = rand;
end

function f = expand(node, edge_domain)
ind = find(edge_domain(:) == node);
sz = length(edge_domain);
pos1 =  rem(floor((ind-1)./sz)+1,2)+1 ;%1 or 2
pos2 = ind - floor((ind-1)./sz).*sz;
A = [pos2 pos1];
for i = 1 : length(A)
    pos(i) = edge_domain(A(i,1),A(i,2));
end
f = pos; 
end
%change Heuristics and create a new object for robot
function f = returnh(open,goal,robot)
for i = 1 : length(open)
    if robot.domain(open(i),3) == 0
        dist = inf;
    else 
        dist = sqrt((robot.domain(open(:),1) - robot.domain(goal,1)).^2 + (robot.domain(open(:),2) - robot.domain(goal,2)).^2);
    end
end
f = dist ;
end

function f = givecost(current_node, open, robot)
distance = [];
for i = 1 : length(open)
    pos = search_edge(open(i),current_node, robot);
    if robot.domain(open(i),4) == 0
        if robot.edge_domain(pos,3) == 1000000
            distance = vertcat(distance, sqrt((robot.domain(open(i),1) - robot.domain(current_node,1)).^2 + (robot.domain(open(i),2) - robot.domain(current_node,2)).^2));
        else
    %         dist(i) = sqrt((robot.domain(open(i),1) - robot.domain(current_node,1)).^2 + (robot.domain(open(i),2) - robot.domain(current_node,2)).^2);
            distance = vertcat(distance, robot.edge_domain(pos,3));
        end
    else 
        distance = vertcat(distance, inf);
    end
end
f = distance;
end

function store_in_cost(robot, open, total_cost)
for i = 1 : length(open)
    if total_cost(i) < robot.cost(open(i))
        robot.cost(open(i)) = total_cost(i);
%     elseif robot.domain(open(i),4) == 1
%         robot.cost(open(i)) = inf;
    end
end
end

% function f = move_forward(robot, open, current_node)
% if  isempty(open) == 0
%     [~, pos] = min(robot.cost(open));
% 
%     cost = search_edge(open(pos),current_node, robot);
%     if isempty(cost)
%         answer = is_feasible_edge(current_node, open(pos),robot);
%         if answer(3) == 0
%             next_node = nearest(open, robot);
%             robot.edge_domain = vertcat(robot.edge_domain, [open(pos) current_node inf]);
%         else
%             if robot.domain(open(pos),4) == 1
%             open(pos) = [];
%             move_forward(robot, open, current_node)
%             end
%             next_node = open(pos);
%             robot.edge_domain = vertcat(robot.edge_domain, [open(pos) current_node 0]);
%         end
%     else
%         if robot.edge_domain(cost,3) == 0
%             if robot.domain(open(pos),4) == 1
%             open(pos) = [];
%             move_forward(robot, open, current_node)
%             end
%             next_node = open(pos);
%             robot.current_pos = robot.domain(next_node,1:2);
%         else
%             robot.cost(open(pos)) = inf;
%             open(pos) = [];
%             next_node = move_forward(robot, open, current_node);
%         end
%     end
%     f  = next_node;
% else
%     robot.current_pos = current_node;
%     f = [current_node 1];
% end
% end

function f = move_forward(robot, open, current_node)
if  isempty(open) == 0
    [dist, pos] = min(robot.cost(open));
    edge_pos = search_edge(open(pos),current_node, robot);
    if is_feasible_edge(current_node, open(pos), robot) == 0
        next_node = open(pos);
        if robot.edge_domain(edge_pos,3) == 1000000 
            robot.edge_domain(edge_pos,3) = dist;
        end
    else
        robot.edge_domain(edge_pos,:) = [];
        current_pos = robot.current_pos;
        next_node = nearest(open, robot);        
        robot.cost(open(pos)) = inf;
        open(pos) = [];
        if next_node == current_node
            next_node = move_forward(robot, open, current_node);
        elseif next_node ~= 0
            robot.domain = vertcat(robot.domain, [current_pos 1 1 1]);
            robot.edge_domain = vertcat(robot.edge_domain,[current_node length(robot.domain) distance(current_node, length(robot.domain), robot)] );
            robot.edge_domain = vertcat(robot.edge_domain,[next_node length(robot.domain) distance(next_node, length(robot.domain), robot)] );
        end
    end
    f  = next_node;
else
    robot.current_pos = robot.domain(current_node,1:2);
    f = 0;
end
end



function f = search_edge(pos,current_node, robot)
if isempty(robot.edge_domain) == 0
    indx = find(robot.edge_domain(:,1) == pos);
    indy = find(robot.edge_domain(:,2) == current_node);
    ind = intersect(indx, indy);
    if isempty(ind)
        indx = find(robot.edge_domain(:,2) == pos);
        indy = find(robot.edge_domain(:,1) == current_node);
        ind = intersect(indx, indy);
    end
else
    ind = [];
end
f = ind;
end

%shoulld I consider point llabels as they wont make any differences.

function f = nearest(open, robot)
for i  = 1 : length(open)
    dist = sqrt((robot.domain(open(:),1) - robot.current_pos(1)).^2 + (robot.domain(open(:),2) - robot.current_pos(2)).^2);
    [~, pos] = min(dist);
    cost = is_feasible_edge(robot.current_pos,open(pos),robot);
    if cost == 0
            break;
    else
        open(pos) = [];
    end
end
if isempty(open) == 1
    f = 0;
else
    f = open(pos);
end
end

function f = distance(node1, node2 , robot)
f = sqrt((robot.domain(node1,1) - robot.domain(node2,1)).^2 + (robot.domain(node1,2) - robot.domain(node2,2)).^2);
end