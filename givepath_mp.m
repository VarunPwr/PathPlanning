tic;
answer = inputdlg('Enter space-separated intial point:',...
             'Sample', [1 50]);
x_initial = str2num(answer{1});

answer = inputdlg('Enter space-separated final point:',...
             'Sample', [1 50]);
x_final = str2num(answer{1});
initial_assign = [x_initial(1);x_initial(2);x_initial(3)];
    final_assign = [x_final(1);x_final(2);x_final(3)];
    if feasible_domain_mp([initial_assign(1) initial_assign(2) initial_assign(2)]) == 1 && feasible_domain_mp([final_assign(1) final_assign(2) final_assign(3)]) == 1
%         V = vertcat(feasible_domain(:,1:3),infeasible_domain(:,1:3),initial_assign',final_assign');
        V = MP.domain;
        sz = size(V);
        I = delaunay(V(:,1),V(:,2),V(:,3));
        J_1 = I(:,[2 3 4 1]); E_1 = [I(:) J_1(:)];
        J_2 = I(:,[3 4]);
        I_2 = I(:,[1 2]);
        E_2 = [I_2(:) J_2(:)];
        E = vertcat(E_1,E_2);% 1 2 3 4 -2 3 4 1 & 1 2  - 3 4 
        [costs,paths] = dijkstra_mp(V,E,sz(1),sz(1)-1,MP);
        %%%%%%%%%%%%%%%%%%
        t = paths;
%         if isnan(paths{1,1}) == 0
%             t = paths{1,1};
%         elseif isnan(paths{2,1}) == 0
%             t = paths{2,1};
%         elseif isnan(paths{1,2}) == 0
%             t = paths{1,2};
%         elseif isnan(paths{2,2}) == 0
%             t = paths{2,2};    
%         end
        %%%%%%%%%%%%%%%%%%
        x_path = MP.domain(t',1);
        y_path = MP.domain(t',2);
        z_path = MP.domain(t',3);
        figure
%         t = test_plot(3);
%         plot3(t(:,1),t(:,2),t(:,3),'.y')
%         alpha(0.5)
%         hold on
        plot3(x_path,y_path,z_path,'-r')
        hold on
        plot3(feasible_domain(:,1),feasible_domain(:,2),feasible_domain(:,3),'.g')
        hold on 
        plot3(infeasible_domain(:,1),infeasible_domain(:,2),infeasible_domain(:,3),'.r')
        hold off;
    else
        disp('invalid input')
    end
clear x_initial x_final
toc;