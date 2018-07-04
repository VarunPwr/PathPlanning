tic;
global infeasible_domain
global feasible_domain
figure
t(:,1:2) = 50 * rand(1000000,2) - 50 * rand(1000000,2);
t(:,3) = -10 * rand(1000000,1);
for i = 1 : 1000000
    if feasible_domain_mp([t(i,1) t(i,2) t(i,3)]) == 1
        t(i,:) = [0,0,0];
    end

end
plot3(t(:,1),t(:,2),t(:,3),'.y');
hold on 
a = 1;
b = 1;

for i = 1 : length(MP.domain) 
    if MP.domain(i,4) == -1
        infeasible_domain(a,1) = MP.domain(i,1);
        infeasible_domain(a,2) = MP.domain(i,2);
        infeasible_domain(a,3) = MP.domain(i,3);
        a = a + 1;
    else
        feasible_domain(b,1) = MP.domain(i,1);
        feasible_domain(b,2) = MP.domain(i,2);
        feasible_domain(b,3) = MP.domain(i,3);
        b = b + 1;
    end
end 
plot3(infeasible_domain(:,1),infeasible_domain(:,2),infeasible_domain(:,3),'or')
hold on
plot3(feasible_domain(:,1),feasible_domain(:,2),feasible_domain(:,3),'og')
hold off 
toc;