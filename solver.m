function [results, numberOfElements] = solver(path,endtime,numberOfSteps)
time = linspace(0,endtime,numberOfSteps);
h=time(2)-time(1);
[elements,connections,guidings]=read(path);
numberOfElements = width(elements)-1;
sizeOfq = 3*numberOfElements;
q = zeros(sizeOfq,1);
results = struct('q',zeros(sizeOfq,numberOfSteps),'q_prim',zeros(sizeOfq,numberOfSteps),...
    'q_bis',zeros(sizeOfq,numberOfSteps));
iter = 1;
for element = elements(2:end)
    q(iter:iter+2) = [element.ACS_cm;element.angle];
    iter = iter+3;
end
iter = 1;
for t = time
    [q,q_prim,FI_q] = velocities(q,elements,connections,guidings,t);
    q_bis = accelerations(q,q_prim,FI_q,elements,connections,guidings,t);
    results.q(:,iter) = q;
    results.q_prim(:,iter) = q_prim;
    results.q_bis(:,iter) = q_bis;
    q = q+q_prim*h+q_bis*h^2/2;
    iter = iter+1;
end