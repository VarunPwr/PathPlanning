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
    end
    i = i + 1;
end
f = rand;
end
