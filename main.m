tp = 0;
h = .05;
tk = 1.5;
t=tp;
numberOfSteps = round((tk-tp)/h);
[elements,connections,guidings]=read('test.xlsx');
sizeOfq = 3*(width(elements)-1);
q = zeros(sizeOfq,1);
results = struct('q',zeros(sizeOfq,numberOfSteps),'q_prim',zeros(sizeOfq,numberOfSteps),...
    'q_bis',zeros(sizeOfq,numberOfSteps));
iter = 1;
for element = elements(2:end)
    q(iter:iter+2) = [element.ACS_cm;element.angle];
    iter = iter+3;
end
iter = 1;
while(t<tk+h)
    [q,q_prim,FI_q] = velocities(q,elements,connections,guidings,t);
    q_bis = accelerations(q,q_prim,FI_q,elements,connections,guidings,t);
    results.q(:,iter) = q;
    results.q_prim(:,iter) = q_prim;
    results.q_bis(:,iter) = q_bis;
    %tutaj zapis do pliku
    q = q+q_prim*h+q_bis*h^2/2;
    t=t+h;
    iter = iter+1;
end