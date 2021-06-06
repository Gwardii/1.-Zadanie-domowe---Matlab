%Prosta klasa do obsługi pojedyńczego elementu 2D
%Wszystkie wektory sa kolumnowe
%i-ta kolumna w vertices opisuje i-ty wierzchołek
%Wszystkie współrzędne powinny być tak wprowadzone, aby w położeniu
%początkowym angle = 0 w przeciwnym wypadku należy podać także kąt
classdef element2D < handle
    properties
        ACS_cm(2,1) double %współrzędne środka masy w globalnym układzie współrzędnych
        vertices(2,:) double %współrzędne wierzchołków w lokalnym układzie współrzędnych związanym z środkiem masy członu
        angle(1,1) double = 0 %kąt między LUW, a GUW
        mass(1,1) double
        moment_of_inertia (1,1) double
    end
    methods
        function obj = element2D(ACS_cm, mass, moment_of_inertia)
            obj.ACS_cm = ACS_cm;
            obj.mass = mass;
            obj.moment_of_inertia = moment_of_inertia;
        end
        function [] = add_vertice(obj,vertice)
            obj.vertices = [obj.vertices,vertice];
        end
    end
end