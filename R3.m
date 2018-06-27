function f = R3(d)
%make sure that all values are in radian
%l1 is the arm length
q = [ 1 0 0 0];
p = [0 0 -d];
%%base is at the same height as the mainpulator arm
f = [q p];
end