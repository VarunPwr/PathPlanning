function f = quatmultiply(q1,q2)
%make sure that q is a horizontal vector
%quaternion is  a four dimensional vector q1 * q2 = [s1s2 - v1. v2, s1v2 + s2v1 + v2 x v1]
f =  [q1(1)*q2(1) - dot(q1(2:4),q2(2:4)),q1(1)*q2(2:4) + q2(1)*q1(2:4) + cross(q2(2:4),q1(2:4))];
end