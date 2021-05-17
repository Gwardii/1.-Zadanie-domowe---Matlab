function plot_point(point, element_no, results, time)
Omega = [0, -1; 1, 0];
rs  = results.q([3*element_no-2,3*element_no-1],:); %współrzędne LUW
fis = results.q(3*element_no,:); %kąt LUW
r_prims = results.q_prim(3*element_no-2:3*element_no-1,:);
fi_prims = results.q_prim(3*element_no,:);
r_biss = results.q_bis(3*element_no-2:3*element_no-1,:);
fi_biss = results.q_bis(3*element_no,:);
iter = 1;
for fi = fis
    R = Rot(fi);
    rs(:,iter) = rs(:,iter) + R*point; %policz współrzędne punktu w układzie absolutnym
    r_prims(:,iter) = r_prims(:,iter) + Omega*R*point*fi_prims(iter); %prędkość
    r_biss(:,iter) = r_biss(:,iter) + Omega*R*point*fi_biss(iter) - R*point*fi_prims(iter)^2; %przyśpieszenie
    iter = iter+1;
end
figure('Name',sprintf('Wyniki dla punktu [%g; %g] związanego z członem %d.',point,element_no),...
    'NumberTitle','off', 'Position',[-10,-10,1000,800]);
titles = ["Położenie x ";"Położenie y ";"Prędkość x ";"Prędkość y ";"Przyśpieszenie x ";"Przyśpieszenie y "];
tiledlayout(3,2)
for i = 0:1
    tile = nexttile;
    plot(tile,time,rs(i+1,:))
    title(tile,strcat(titles(i+1),'punktu'));
    xlabel(tile, 'Czas [s]')
    ylabel(tile, strcat(titles(i+1),'[m]'))
end
for i = 0:1
    tile = nexttile;
    plot(tile,time,r_prims(i+1,:))
    title(tile,strcat(titles(i+3),'punktu'));
    xlabel(tile, 'Czas [s]')
    ylabel(tile, strcat(titles(i+3),'[m]'))
end
for i = 0:1
    tile = nexttile;
    plot(tile,time,r_biss(i+1,:))
    title(tile,strcat(titles(i+5),'punktu'));
    xlabel(tile, 'Czas [s]')
    ylabel(tile, strcat(titles(i+5),'[m]'))
end
end