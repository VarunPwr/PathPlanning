function f = feasible_edge_mp(pos1,pos2)
%presence of obstacle given by inertial sensor
%pos1 and pos2 is in radial basis
sol_space1 = space_manip_map(pos1,-1);
%not a solution but the solution space
sol_space2 = space_manip_map(pos2,-1);
% clear i j cost_theta cost_phi cost sol_space1 sol_space2
%first element is d,second is theta and third is phi
%actual motion dynamics is handled by this function so it is safe to
%introduce three dualquaternion operators for the prismatic and revolutet
%joints
%following is from the paper
%R1 for phi based revolute joint R2 for theta based revolute joint and R3
%for prisamtic joint
%first operate R3

cost = [];
for i = 1 : 2
    for j = 1 : 2
        cost = vertcat(cost, abs(sol_space1(i,2) - sol_space2(j,2)) + abs(sol_space1(i,3) - sol_space2(j,3)));
    end
end

% cost = [];
% for i =1 :4
%     for j =1:4
%         cost = vertcat(cost,cost_theta(i) + cost_phi(j));
%     end
% end
%remember quaternion is a useless quantity of the spce it doesnot provide
%any information about the orientatin just the commulative angle traversed.
%indx is like x then y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,indx] = min(cost);
%redifine i and j for cost_theta and cost_phi respectively
%i = (indx-1)mod4 + 1;j = (indx-1)%4
%j = indx(1) && i = indx(2) so floor((j-1)/2)for solspace1 and rem(j-1,2)for solspace2
%for both i and j i-1 mod 2  +1 and i-1%2 +1 is indx of sol1 and sol2
%respectively
i = floor((indx-1)/2) +1 ;
j = rem(indx-1,2) +1 ;
sol1 = [sol_space1(1,1),sol_space1(i,2),sol_space1(i,3)];
sol2 = [sol_space2(1,1),sol_space2(j,2),sol_space2(j,3)];%%both solutions placed
vector = dualquatmultiply(R1(sol1(3)),dualquatmultiply(R2(sol1(2)),R3(sol1(1))));%%operator is working fine
chk =1;
figure
for i = 0 : 0.01 : 1
    vector = dualquatmultiply(R3((sol2(1) - sol1(1))*0.01),vector);%%first all prismatic motion is enabled
    pos = [sol1(1)*(1-i) + sol2(1)*i,sol1(2:3)];
    if mainpulator_chk(pos) == -1
       chk = -1;
       break;
    else
        continue;
    end
    %chk feasibililty of all arms 
end
%%%%%%%%%%%%%
%make sure that the vector rotation also includes the translation 
if chk == 1 
    for i = 0 : 0.01 : 1 
        vector = dualquatmultiply(R1(sol1(3)),dualquatmultiply(R2(sol1(2)*(1-i) + sol2(2)*i),R3(sol2(1))));%%first all prismatic motion is enabled
        pos = [sol2(1),sol1(2)*(1-i) + sol2(2)*i,sol1(3)];
        if mainpulator_chk(pos) == -1
           chk = -1;
           break;
        else
            continue;
        end
        %chk feasibililty of all arms 
    end%%first all prismatic motion is enabled
end
%%%%%%%%%%%%%
if chk == 1
    for i = 0 : 0.01 : 1
        vector = dualquatmultiply(R1(sol1(3)*(1-i) + sol2(3)*i),dualquatmultiply(R2(sol2(2)),R3(sol2(1))));%%first all prismatic motion is enabled
        pos = [sol2(1),sol2(1),sol1(3)*(1-i) + sol2(3)*i];
        if mainpulator_chk(pos) == -1
           chk = -1;
           break;
        else
            continue;
        end
        
        %chk feasibility of all arms
    end
end
if chk == 1
    f = vector(5:7);
end
f = vector(5:7);
end
