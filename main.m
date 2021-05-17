%main 
path='kinematyka5.xlsx';
endtime = 1.5;
numberOfSteps = 31;
%uzupełnij parametry powyżej
time = linspace(0,endtime,numberOfSteps);
[results, numberOfElements] = solver(path,endtime,numberOfSteps);
%funkcje do rysowania wykresów:
%rysuj wykresy dla członu nr. element_no
plot_result = @(element_no)plot_result(element_no,results,time);
%rysuj wykresy dla punktu związanego z członem nr. element_no o
%współrzędnych point w układzie związanym z członem
plot_point_lcs = @(point,element_no)plot_point(point,element_no,results,time);
%rysuj wykresy dla punktu związanego z członem nr. element_no o
%współrzędnych point w fazie początkowej w układzie absolutnym
plot_point_acs = @(point,element_no)...
    plot_point(point-results.q(3*element_no-2:3*element_no-1,1),element_no,results,time);