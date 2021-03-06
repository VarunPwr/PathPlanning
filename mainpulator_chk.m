function f = mainpulator_chk(pos)
%it checks whether the given manipulator orientation is feasible or not
d = pos(1);
theta = pos(2);
phi = pos(3);

joint1 = R1(phi);
joint1 = joint1(5:7);

joint2 = dualquatmultiply(R1(phi),R2(theta));
joint2 = joint2(5:7);

joint3 = dualquatmultiply(dualquatmultiply(R1(phi),R2(theta)),R3(d));
joint3 = joint3(5:7);


% axis([-100 100 -100 100 -15 15])
% plot3([joint3(1),joint2(1)],[joint3(2),joint2(2)],[joint3(3),joint2(3)], '-')
% hold on 
% plot3([joint1(1),0],[joint1(2),0],[joint1(3),0], '-')
% hold on 
% plot3([joint2(1),joint1(1)],[joint2(2),joint1(2)],[joint2(3),joint1(3)], '-')
% pause(0.1)
% cla    


for i = 0 : 0.01 : 1
    if feasible_domain_mp(joint1*i) == 1 && feasible_domain_mp(joint2*i +joint1) == 1 && feasible_domain_mp(joint3*i +joint2 + joint1) == 1
        continue;
    else
        f = -1;
        
    end
end
f = 1;
end
%%till here everything is in dual quaternion space but is feasible is in
%%simple 3d cartesian space
%make sure that feasible_domain_mp returns 1 for feasibility