function f = dualquatmultiply(Q1,Q2)
%dual quaternion is a 7 dimensional vector 
%cos(theta/2) sin(theta/2)*i sin(theta/2)*j sin(theta/2)*k x y z where
%first four  is a single quaternion denoting the direction of a spatial
%vecotr while the next is the direction vector . So a dual quaternion is
%represented by Q = [q,p]
%make sure that Q is a horizontal vector
q1 = Q1(1:4);
q2 = Q2(1:4);
p1 = Q1(5:7);
p2 = Q2(5:7);
%q1 * q2 = [s1s2 - v1.V2, s1v2 + s2v1 + v2 x v1] & 
f = [quatmultiply(q1,q2),p1 + p2 + 2*q1(1)*cross(q1(2:4),p2) + cross(2*q1(2:4) ,cross (q1(2:4),p2))];
end