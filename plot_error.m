function plot_error(results,time)
figure('Name','Błędy','NumberTitle','off','Position',[-10,-10,1600,800]);
tiledlayout(3,1);
tile = nexttile;
plot(tile,time,results.q_error)
title(tile,'Błąd położeń');
xlabel(tile, 'Czas [s]')
ylabel(tile, 'Norma wektora błędu')

tile = nexttile;
plot(tile,time,results.q_prim_error)
title(tile,'Błąd predkości');
xlabel(tile, 'Czas [s]')
ylabel(tile, 'Norma wektora błędu')

tile = nexttile;
plot(tile,time,results.q_bis_error)
title(tile,'Błąd przyśpieszeń');
xlabel(tile, 'Czas [s]')
ylabel(tile, 'Norma wektora błędu')
end