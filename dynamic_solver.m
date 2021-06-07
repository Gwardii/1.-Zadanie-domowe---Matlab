function [results,time,numberOfElements] = dynamic_solver(path,endtime)
[elements,connections,~,damping_springs,forces,moments]=read(path);
numberOfElements = width(elements)-1;
sizeOfq = 3*numberOfElements;
q = zeros(sizeOfq,1);
q_prim = q;
% results = struct('q',zeros(sizeOfq,numberOfSteps),'q_prim',zeros(sizeOfq,numberOfSteps),...
%     'q_bis',zeros(sizeOfq,numberOfSteps));
iter = 1;
for element = elements(2:end)
    q(iter:iter+2) = [element.ACS_cm;element.angle];
    iter = iter+3;
end
mass_matrix(elements);
constraints(q,0,elements,connections);
gammaFunction(q,q_prim,0,elements,connections);
generalized_forces(q,q_prim,elements,connections,damping_springs,forces,moments);
Y0=[q;q_prim];
[time,Y]=ode45(@equations,[0,endtime],Y0);
results.q = Y(:,1:sizeOfq)';
results.q_prim = Y(:,sizeOfq+1:end)';
results.q_bis = results.q;
results.q_error = time;
results.q_prim_error = time;
results.q_bis_error = time;
iter = 1;
for t = time'
    [dY,FI,FI_q,Gamma] = equations(t,Y(iter,:)');
    results.q_bis(:,iter) = dY(sizeOfq+1:end);
    results.q_error(iter) = norm(FI);
    results.q_prim_error(iter) = norm(FI_q*dY(1:sizeOfq));
    results.q_bis_error(iter) = norm(FI_q*dY(sizeOfq+1:end)-Gamma);
    iter = iter+1;
end
end
function [dY,FI,FI_q,Gamma] = equations(t,Y)
alfa = 5;
beta = alfa;
q = Y(1:height(Y)/2);
q_prim = Y(height(Y)/2+1:end);
M = mass_matrix();
[FI,FI_q] = constraints(q,t);
Gamma = gammaFunction(q,q_prim,t);
Q = generalized_forces(q,q_prim);
q_bis = [M,FI_q';FI_q,zeros(height(FI_q))]\[Q;Gamma-2*alfa*FI_q*q_prim-beta^2*FI];
q_bis = q_bis(1:height(M));
dY = [q_prim;q_bis];
end