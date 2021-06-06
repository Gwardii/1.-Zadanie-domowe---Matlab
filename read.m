function [elements,connections,guidings,damping_springs,forces,moments] = read(path)
A = readmatrix(path,'Range','A2','Sheet','Człony');
B = readmatrix(path,'Range','A2','Sheet','Połączenia');
[~,~,C] = xlsread(path,'Połączenia');
C=C(2:end,8);
D = readmatrix(path,'Range','A2','Sheet','Siły');
connections=struct('pin',pin.empty,'slider',slider.empty);
guidings = struct('whichConnection',[],'formula',[]);
guidings = guidings([]);
damping_springs = struct('whichConnection',[],'k',[],'c',[]);
damping_springs = damping_springs([]);
forces = struct('whichElement',[],'whichVertex',[],'value',[]);
forces = forces([]);
moments = struct('whichElement',[],'value',[]);
moments = moments([]);
k=1;
l=1;
for i = 1:height(A)
    elements(i) = element2D(A(i,1:2),A(i,3),A(i,4));
    for j = 5:2:width(A)
        if isnan(A(i,j))
            break
        end
        elements(i).add_vertice(A(i,[j,j+1])');
    end
end
for i = 1:height(B)
    if isnan(B(i,5))
        connections.pin(k)=pin(B(i,[1,2]),B(i,[3,4]));
        k=k+1;
    else
        connections.slider(l) = slider(B(i,[1,2]),B(i,[3,4]),B(i,[5,6]),B(i,7));
        l=l+1;
    end
    if ~isnan(B(i,9))
        damping_spring.whichConnection = i;
        damping_spring.k = B(i,9);
        damping_spring.c = B(i,10);
        damping_springs(end+1)=damping_spring;
    end
end
for i = 1:height(C)
    if ~isnan(C{i})
        guiding.whichConnection = i;
        guiding.formula = @(t)eval(C{i});
        guidings(end+1) = guiding;
    end
end
for i = 1:height(D)
    force.whichElement = D(i,1);
    if isnan(D(i,2))
        force.value = D(i,3);
        moments(end+1) = force;
    else
        force.whichVertex = D(i,2);
        force.value = D(i,3:4)';
        forces(end+1) = force;
    end
end
        