classdef pin < handle
    properties
        connection(2,1) double {mustBeInteger}%wektor opisujący które człony są połączone [i;j]
        vertices(2,1) double %wektor opisujący, które wierzchołki sa połączone
    end
    methods
        function obj = pin(connection,vertices)
            if connection(1) == connection(2)
                throw(MException('MyComponent:sameElements','Nie można połączyć członu z nim samym'))
            end
            obj.connection = connection;
            obj.vertices = vertices;
        end
    end
end