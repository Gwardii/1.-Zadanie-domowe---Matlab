function plot_result(element_no,results,time)
figure('Name',sprintf('Wyniki dla członu %d.',element_no),'NumberTitle','off',...
    'Position',[-10,-10,1600,800]);
titles = ["Położenie x ";"Położenie y ";"Kąt ";"Prędkość x ";"Prędkość y ";...
    "Prędkość kątowa ";"Przyśpieszenie x ";"Przyśpieszenie y ";"Przyśpieszenie kątowe "];
tiledlayout(3,3)
for i = 0:2
    tile = nexttile;
    plot(tile,time,results.q(3*element_no+i-2,:))
    title(tile,strcat(titles(i+1),sprintf('członu %d.',element_no)));
    xlabel(tile, 'Czas [s]')
    ylabel(tile, strcat(titles(i+1),'[m]'))
end
for i = 0:2
    tile = nexttile;
    plot(tile,time,results.q_prim(3*element_no+i-2,:))
    title(tile,strcat(titles(i+4),sprintf('członu %d.',element_no)));
    xlabel(tile, 'Czas [s]')
    ylabel(tile, strcat(titles(i+4),'[m]'))
end
for i = 0:2
    tile = nexttile;
    plot(tile,time,results.q_bis(3*element_no+i-2,:))
    title(tile,strcat(titles(i+7),sprintf('członu %d.',element_no)));
    xlabel(tile, 'Czas [s]')
    ylabel(tile, strcat(titles(i+7),'[m]'))
end
end