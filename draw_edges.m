%draw infeasible edges

figure

for i = 1 : length(robot.edge_domain)
    if (robot.edge_domain(i,3)) == 1000000
        plot([robot.domain(robot.edge_domain(i,1),1) robot.domain(robot.edge_domain(i,2),1)], [robot.domain(robot.edge_domain(i,1),2) robot.domain(robot.edge_domain(i,2),2)], '-y') 
        hold on
%         if count == 2
%             break;
%         end
    elseif (robot.edge_domain(i,3)) == inf
        plot([robot.domain(robot.edge_domain(i,1),1) robot.domain(robot.edge_domain(i,2),1)], [robot.domain(robot.edge_domain(i,1),2) robot.domain(robot.edge_domain(i,2),2)], '-r') 
        hold on  
    else
        plot([robot.domain(robot.edge_domain(i,1),1) robot.domain(robot.edge_domain(i,2),1)], [robot.domain(robot.edge_domain(i,1),2) robot.domain(robot.edge_domain(i,2),2)], '-g') 
        hold on  
    end
end