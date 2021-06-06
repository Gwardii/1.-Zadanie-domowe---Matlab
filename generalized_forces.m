function Q = generalized_forces(q,q_prim,varargin)
%lack of implementation springs connected directly to ground
persistent elements connections damping_springs forces moments
if nargin > 2
    elements = varargin{1};
    if nargin > 3
        connections = varargin{2};
        if nargin > 4
            damping_springs = varargin{3};
            if nargin > 5
                forces = varargin{4};
                if nargin > 6
                    moments = varargin{5};
                end
            end
        end
    end
end
Omega = [0,-1;1,0];
g = 9.80665;
size_of_q = 3*width(elements)-3;
Q = zeros(size_of_q,1);
iter = 2;
persistent d0
if ~isempty(varargin)
    d0 = ones(size_of_q,1)*nan;
end
    
for element = elements(2:end)
    Q(iter) = -element.mass*g;
    iter = iter+3;
end
for moment = moments
    i = moment.whichElement + 1; %-1 +2 =1
    Q(i) =Q(i) + moment.value;
end
for force  = forces
    i = force.whichElement;
    j = force.whichVertex;
    vertex = elements(i).vertices(:,j);
    i = 3*(i-1)-2;
    R = Rot(q(i+2));
    Q(i:i+2) =Q(i:i+2) + [force.value;(Omega*R*vertex)'*force.value];
end
for spring = damping_springs
    k = spring.k;
    c = spring.c;
    wC = spring.whichConnection;
    n = width(connections.pin);
    if wC > n
        connection = connections.slider(wC-n);
        i = connection.connection(1);
        j = connection.connection(2);
        Sa = elements(i).vertices(:,connection.vertices(1));
        Sb = elements(j).vertices(:,connection.vertices(2));
        i=3*(i-1)-2;
        j=3*(j-1)-2;
        r_i = q(i:i+1);
        r_j = q(j:j+1);
        fi_i = q(i+2);
        fi_j = q(j+2);
        r_i_prim = q_prim(i:i+1);
        r_j_prim = q_prim(j:j+1);
        R_i = Rot(fi_i);
        R_j = Rot(fi_j);
        fi_i_prim = q_prim(i+2);
        fi_j_prim = q_prim(j+2);
        u = r_j + R_j*Sb - r_i - R_i*Sa;
        d = norm(u);
        u = u/d;
        if isnan(d0(wC))
            d0(wC) = d;
        end
        v_j = r_j_prim + Omega*R_j*Sb*fi_j_prim;
        v_i = r_i_prim + Omega*R_i*Sa*fi_i_prim;
        d_prim = u'*(v_j-v_i);
        F = u*(k*(d-d0(wC))+c*d_prim);
        Q(i:i+2) = Q(i:i+2) + [eye(2);(Omega*R_i*Sa)']*F;
        Q(j:j+2) = Q(j:j+2) - [eye(2);(Omega*R_i*Sa)']*F;
    else
        %todo implementation for rotation springs
    end
        
end

    