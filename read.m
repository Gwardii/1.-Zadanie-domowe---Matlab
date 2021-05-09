function [elements,connections,guidings] = read(path)
A = readmatrix(path,'Range','A2','Sheet','Człony');
B = readmatrix(path,'Range','A2','Sheet','Połączenia');
[~,~,C] = xlsread(path,'Połączenia');
C=C(2:end,8);
connections=struct('pin',pin.empty,'slider',slider.empty);
guidings = struct('whichConnection',[],'formula',[]);
guidings = guidings([]);
k=1;
l=1;
for i = 1:height(A)
    elements(i) = element2D(A(i,1:2));
    for j = 3:2:width(A)
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
end
for i = 1:height(C)
    if ~isnan(C{i})
        guiding.whichConnection = i;
        guiding.formula = @(t)eval(C{i});
        guidings(end+1) = guiding;
    end
end