function f = R1(phi)
%make sure that all values are in radian
%l1 is the arm length
l1 = 50;
q = [ cos(phi/2) 0 0 sin(phi/2)];
p = [l1*cos(phi) l1*sin(phi) 0];
%%base is at the same height as the mainpulator arm
f = [q p];
end