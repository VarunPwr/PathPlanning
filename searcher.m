function f= searcher(domain, pos1, pos2,E)
%%seracher is triple function domain ,pos gives index to a pos in domain
%%domain pos1 pos2 E gives index to pos1 pos2 in domain in E
%%domain pos E gives index of pos in E
narginchk(2,4)
chk = 0;
if nargin == 2
    indx = find(domain(:,1) == pos1(1));
    indy = find(domain(:,2) == pos1(2));
    chk = intersect(indx,indy);
elseif nargin == 4
    %                 r = rem(indx(i)-1,length(E)) + 1
    %                 d = floor((indx(i)-1)/length(E)) +1

    ind1 = find(E(:,1) == pos1);
    ind2 = find(E(:,2) == pos2);
    chk = intersect(ind1,ind2);

%     for i =1 : length(E)
%         if E(i,1) == pos1
%             if E(i,2) == pos2
%                 chk = i;
%                 break;
%             end
%         elseif E(i,2) == pos1 
%             if E(i,1) == pos2 
%                 chk = i;
%                 break;
%             end 
%         else
%             continue;
%         end
%     end
else
    disp('invalid number of arguments')
end
f = chk;
end