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


plot([joint1(1),0],[joint1(2),0], '-')
hold on 
plot([joint2(1),joint1(1)],[joint2(2),joint1(2)], '-')
axis([-100 100 -100 100])
pause(0.1)
cla    


for i = 0 : 0.01 : 1
    if feasible_domain_mp(joint1*i) && feasible_domain_mp(joint2*i +joint1) && feasible_domain_mp(joint3*i +joint2 + joint1)
        continue;
    else
        f = -1;
        
    end
end
f =1;
end
%%till here everything is in dual quaternion space but is feasible is in
%%simple 3d cartesian space
%make sure that feasible_domain_mp returns 1 for feasibility