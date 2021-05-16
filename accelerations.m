function [q_bis,Gamma] = accelerations(q,q_prim,FI_q,elements,connections,guidings,t)
Omega = [0,-1;1,0];
Gamma = zeros(height(q),1);
iter = 1;
for connection = connections.pin
    i=connection.connection(1);
    j=connection.connection(2);
    Sa = elements(i).vertices(:,connection.vertices(1));
    Sb = elements(j).vertices(:,connection.vertices(2));
    i=3*(i-1)-2;
    j=3*(j-1)-2;
    if i <= 0
        fi_j = q(j+2);
        R_j = Rot(fi_j);
        Gamma([iter,iter+1]) = -R_j*Sb*q_prim(j+2)^2;
    elseif j <= 0
        fi_i = q(i+2);
        R_i = Rot(fi_i);
        Gamma([iter,iter+1]) = R_i*Sa*q_prim(i+2)^2;
    else
        fi_i = q(i+2);
        fi_j = q(j+2);
        R_i = Rot(fi_i);
        R_j = Rot(fi_j);
        Gamma([iter,iter+1]) = R_i*Sa*q_prim(i+2)^2-R_j*Sb*q_prim(j+2)^2;
    end
    iter = iter+2;
end
for connection = connections.slider
    i=connection.connection(1);
    j=connection.connection(2);
    Sa = elements(i).vertices(:,connection.vertices(1));
    i=3*(i-1)-2;
    j=3*(j-1)-2;
    if i <= 0
        r_j = q([j,j+1]);
        fi_j = q(j+2);
        r_j_prim = q_prim([j,j+1]);
        fi_j_prim = q_prim(j+2);
        R_j = Rot(fi_j);
        v = connection.v;
        Gamma(iter) = -2*(Omega*R_j*v)'*r_j_prim*fi_j_prim+...
            (R_j*v)'*(r_j-Sa)*fi_j_prim^2;
    elseif j <= 0
        fi_i = q(i+2);
        fi_i_prim = q_prim(i+2);
        R_i = Rot(fi_i);
        v = connection.v;
        Gamma(iter) = -v'*R_i*Sa*fi_i_prim^2;
    else
        r_i = q([i,i+1]);
        r_j = q([j,j+1]);
        fi_i = q(i+2);
        fi_j = q(j+2);
        r_i_prim = q_prim([i,i+1]);
        r_j_prim = q_prim([j,j+1]);
        fi_i_prim = q_prim(i+2);
        fi_j_prim = q_prim(j+2);
        R_i = Rot(fi_i);
        R_j = Rot(fi_j);
        v = connection.v;
        Gamma(iter) = -((Omega*R_j*v)'*(2*fi_j_prim*r_j_prim-fi_j_prim*r_i_prim-...
            2*Omega*R_i*Sa*fi_i_prim*fi_j_prim-fi_j_prim*r_i_prim)+...
            (R_j*v)'*(R_i*Sa*fi_i_prim^2-(r_j-r_i-R_i*Sa)*fi_j_prim^2));
    end
    iter = iter+2;
end
for guiding = guidings
    wC = guiding.whichConnection;
    formula = guiding.formula;
    if wC > width(connections.pin)
        wC = wC-width(connections.pin);
        connection = connections.slider(wC);
        i = connection.connection(1); 
        j = connection.connection(2);
        Sa = elements(i).vertices(:,connection.vertices(1));
        i=3*(i-1)-2;
        j=3*(j-1)-2;
        if i<=0
        r_j = q([j,j+1]);
        fi_j = q(j+2);
        r_j_prim = q_prim([j,j+1]);
        fi_j_prim = q_prim(j+2);
        R_j = Rot(fi_j);
        v = connection.v;
        v = v/norm(v);
        Gamma(iter) = 2*(R_j*v)'*r_j_prim*fi_j_prim+...
            (R_j*Omega*v)'*(r_j-Sa)*fi_j_prim^2;
        elseif j<=0
        fi_i = q(i+2);
        fi_i_prim = q_prim(i+2);
        R_i = Rot(fi_i);
        v = connection.v;
        v = v/norm(v);
        Gamma(iter) = -(Omega*v)'*R_i*Sa*fi_i_prim^2;
        else
        r_i = q([i,i+1]);
        r_j = q([j,j+1]);
        fi_i = q(i+2);
        fi_j = q(j+2);
        r_i_prim = q_prim([i,i+1]);
        r_j_prim = q_prim([j,j+1]);
        fi_i_prim = q_prim(i+2);
        fi_j_prim = q_prim(j+2);
        R_i = Rot(fi_i);
        R_j = Rot(fi_j);
        v = connection.v;
        v = v/norm(v);
        Gamma(iter) = -(-(R_j*v)'*(2*fi_j_prim*r_j_prim-fi_j_prim*r_i_prim-...
            2*Omega*R_i*Sa*fi_i_prim*fi_j_prim-fi_j_prim*r_i_prim)+...
            (R_j*Omega*v)'*(R_i*Sa*fi_i_prim^2-(r_j-r_i-R_i*Sa)*fi_j_prim^2));
        end
    end
    formulaSecondDiff = matlabFunction(diff(sym(formula),2));
    stringFunc = func2str(formulaSecondDiff);
    if stringFunc(3) == ')'
        Gamma(iter) = Gamma(iter)+formulaSecondDiff();
    else
        Gamma(iter) = Gamma(iter)+formulaSecondDiff(t);
    end
    iter = iter+1;
end
q_bis=FI_q\Gamma;
end