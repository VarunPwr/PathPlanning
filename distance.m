function f = distance(node1, node2 , robot)
f = sqrt((robot.domain(node1,1) - robot.domain(node2,1)).^2 + (robot.domain(node1,2) - robot.domain(node2,2)).^2);
end