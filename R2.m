function f = R2(theta)
%make sure that all values are in radian
%l1 is the arm length
l2 = 50;
q = [ cos(theta/2) 0 0 sin(theta/2)];
p = [l2*cos(theta) l2*sin(theta) 0];
%%base is at the same height as the mainpulator arm
f = [q p];
end