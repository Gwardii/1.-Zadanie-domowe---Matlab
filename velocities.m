function [q,q_prim,FI_q] = velocities(q,elements,connections,guidings,t)
%This funciton corrects position of mechanism using Newton-Raphson method.
%Than it solves velocity task.
eps = 1e-14;
iter_max = 20;
[FI,FI_q,FI_t] = constraints(q,elements,connections,guidings,t);
iter = 0;
while(norm(FI) > eps)
    iter = iter+1;
    if iter > iter_max
        throw(MException('MyComponent:tooManyIterations','Metoda Newtona_Raphsona przekroczyła maksymalną liczbę iteracji'))
    end
    delta_q = -FI_q\FI;
    q = q+delta_q;
    [FI,FI_q,FI_t] = constraints(q,elements,connections,guidings,t);
end
q_prim = -FI_q\FI_t;
