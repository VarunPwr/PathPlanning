tic;
clear;
xdomain = 50*rand(500,1) - 50*rand(500,1);
ydomain = 50*rand(500,1) - 50*rand(500,1);
zdomain = -10*rand(500,1);
fdomain = ones(500,1);
rdomain = zeros(500,1);
MP = manipulator_domain;
MP.domain = [xdomain ydomain zdomain fdomain rdomain];
clear xdomain ydomain zdomain rdomain fdomain;
MP.plot3d;
%now domain is 5 dimensional vector space comprising of feasibility of
%domain along with the repeatability to a point
MP.initial_pos1 = [0 0 0];
MP.domain = vertcat(MP.domain, [0 0 0 1 0]);
for i =1 : 50
    dest_node = [50*rand(1,2) -10*rand(1)];
    %feasible_edge_mp(MP);
    if feasible_domain_mp(dest_node)
        dist_prev = inf;
       while MP.initial_pos1(1) ~= dest_node(1) && MP.initial_pos1(2) ~= dest_node(2) && MP.initial_pos1(3) ~= dest_node(3)
    %    for i = 1 : 10
            dist_i = sqrt((MP.domain(:,1) - MP.initial_pos1(1)).^2 + (MP.domain(:,2) - MP.initial_pos1(2)).^2 + (MP.domain(:,3) - MP.initial_pos1(3)).^2);
            dist_f = sqrt((MP.domain(:,1) - dest_node(1)).^2 + (MP.domain(:,2) - dest_node(2)).^2 + (MP.domain(:,3) - dest_node(3)).^2)  ;
            dist = dist_i + dist_f;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            sz = size(dist);
            for i = 1 : length(dist)
                if MP.domain(i, 5) == 1;
                    dist(i) = inf;
                end
            end
            for i = 1 : length(dist)
                if dist_i(i) > dist_f(i)
                    dist(i) = inf;
                end
            end
            [~,pos] = min(dist);
            if dist_prev < dist_f(pos)
                MP.initial_pos2 = dest_node;
                MP.initial_pos1 = feasible_edge_mp(MP);
                break;
            else
                MP.initial_pos2 = MP.domain(pos,1:3)
                MP.initial_pos1 = feasible_edge_mp(MP);
                MP.domain(pos,5) = 1;
                dist_prev = dist_f(pos);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%11%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       end
       clear dist_prev dest_node dist_i dist_f dist val pos;
    else
        dest_node = [50*rand(1,2) -10*rand(1)];
        %x_final = [50*rand(1,2) -10*rand(1)];
    end
    MP.domain(:,5) = 0;
%     MP.domain = vertcat(MP.domain, [MP.initial_pos1 1 0]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close;
toc;