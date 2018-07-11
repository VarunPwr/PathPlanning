function f = feasible_domain_mp(pos)
    obstacle  = [];
    f = 1;
    obstacler = [  pos(1) + 20 < 0, pos(2) + 15 <0, pos(3) + 5 > 0, 1];
    obstacle = vertcat(obstacle, obstacler);
    %     % obstacle 3
    %     obstacler = [ x(1) + 2 * x(2) - 250 > 0, x(1) + 2 * x(2) - 275 < 0, x(3) > 75, x(3) < 100];
    %     obstacle = vertcat(obstacle, obstacler);
    obstacler = [ pos(1) - 50 < 0, pos(2) - 50 < 0, pos(1) > 20 , pos(2) > 25];
    obstacle = vertcat(obstacle, obstacler);
    obstacler = [ pos(1) - 10 < 0, pos(2) - 15 < 0, pos(1) > 2 , pos(3) > -7];
    obstacle = vertcat(obstacle, obstacler);
    obstacler = [];
    %%%%%%%%%%%%%%% lets begin
    obstacle = obstacle * [1 ;1 ;1 ;1];
    if sum(obstacle == 4 ) > 0
        f = -1;
    end
%presence of obstacle given by infrared sensor
end