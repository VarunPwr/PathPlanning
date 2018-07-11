function f = is_feasible_edge(x_initial,x_final,robot)
narginchk(2,3)


if isempty(robot.edge_domain) == 1 || nargin == 2
    ind = [];
else 
    indx = find(robot.domain(:,1) == x_initial(1));
    indy = find(robot.domain(:,2) == x_initial(2));
    ind1 = intersect(indx,indy);
    clear indx indy;

    indx = find(robot.domain(:,1) == x_final(1));
    indy = find(robot.domain(:,2) == x_final(2));
    ind2 = intersect(indx,indy);
    clear indx indy;
    
    indx = find(robot.edge_domain(:,1) == ind1);
    indy = find(robot.edge_domain(:,2) == ind2);
    ind = intersect(indx,indy);
    clear indx indy;
    
end
if isempty(ind) == 1
    
    f = 1;
    sz = size(x_initial);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for t = 0 : 0.001 : 1;%steps associated with the robot consider here a 3 d robot
        x = (1-t) * x_initial + t * x_final;
        if is_feasible_point(x') == 0  
            
            break;
        end
        %associated array is horizontal one
    end
    t = t - .001;
    x = (1-t) * x_initial + t * x_final;
    if nargin == 3
        indx = find(robot.domain(:,1) == x_initial(1));
        indy = find(robot.domain(:,2) == x_initial(2));
        ind1 = intersect(indx,indy);
        clear indx indy;

        indx = find(robot.domain(:,1) == x_final(1));
        indy = find(robot.domain(:,2) == x_final(2));
        ind2 = intersect(indx,indy);
        clear indx indy;
        
        indx = find(robot.domain(:,1) == x(1));
        indy = find(robot.domain(:,2) == x(2));
        ind_pos = intersect(indx,indy);
        if isempty(ind_pos) == 1
            robot.domain = vertcat(robot.domain,[x(1) x(2) 1 0]);
            ind_pos = length(robot.domain);
        end
        clear indx indy;
        robot.edge_domain = vertcat(robot.edge_domain,[ind1 ind2 ind_pos]);
    end
    f = x ;    
    %f = t;
    t = [];
else
   
   final_indx = robot.edge_domain(ind,3);
   f = robot.domain(final_indx,1:2);

    %purpose of this check is to find the feasiblility of check
end
end
