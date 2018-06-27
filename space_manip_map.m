function f = space_manip_map(pos,indx)
%vec could be in space basis or manipulator basis
%include inverse map later
z_max = 0;
l1 =50;
l2 =50;
if indx == -1%inverse map
    d =z_max - pos(3);
    alpha = acos(((l1^2 + l2^2) - pos(1)^2)/(2*l1*l2));
    beta = acos((pos(1)^2 + l1^2 - l2^2)/(2*l1*pos(1)));
    %there are 2 possible solutions to theta(arm2) and phi(arm1)
    theta = [ pi + alpha, pi - alpha];
    phi = [pos(2) + beta, pos(2) - beta];
    f = [d, theta, phi]; %pass all values 
end
end