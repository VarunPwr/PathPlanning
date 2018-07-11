function f = search_edge(MP,x_initial,x_final)
    pos_initial = searchpos(MP,x_initial);
    pos_final = searchpos(MP,x_final);
    indx = find(MP.edge_domain(:,1) == pos_initial);
    indy = find(MP.edge_domain(:,2) == pos_final);
    f = intersect(indx,indy);
end