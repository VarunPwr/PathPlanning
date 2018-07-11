function f = searchpos(MP,x_given)
indx = find(MP.domain(:,1) == x_given(1));
indy = find(MP.domain(:,2) == x_given(2));
indz = find(MP.domain(:,3) == x_given(3));
intrxy = intersect(indx,indy);
f = intersect(intrxy,indz);
end