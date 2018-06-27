function f = space_manip_map(pos,indx)
%vec could be in space basis or manipulator basis
%include inverse map later
z_max = 0;
l1 =50;
l2 =50;
if indx == -1%inverse map
    d =z_max - pos(3);
    alpha = acos(((l1^2 + l2^2) - pos(1)^2)/(2*l1*l2));
    beta = acos((-l2^2 + pos(1)^2 + l1^2 )/(2*l1*pos(1)));
    %there are 2 possible solutions to theta(arm2) and phi(arm1)
    theta = [ pi + alpha, pi - alpha];
    if theta(1) >= 2*pi
        theta(1) = theta(1) - 2*pi;
    elseif theta(1) < 0
        theta(1) = theta(1) + 2*pi;
    elseif theta(1) >= 2*pi
        theta(2) = theta(2) - 2*pi;
    elseif theta(2) < 0
        theta(2) = theta(2) + 2*pi;
    end
    phi = [pos(2) + beta, pos(2) - beta];
    if phi(1) >= 2*pi
        phi(1) = phi(1) - 2*pi;
    elseif theta(1) < 0
        phi(1) = phi(1) + 2*pi;
    elseif phi(1) >= 2*pi
        phi(2) = phi(2) - 2*pi;
    elseif phi(2) < 0
        phi(2) = phi(2) + 2*pi;
    end
    f = [d, theta(1), phi(1);d, theta(2), phi(2)]; %pass all values 
end
end