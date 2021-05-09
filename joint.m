classdef pin < handle
    properties
        connection(2,1) double {mustBeInteger}%wektor opisujący które człony są połączone [i;j]
        Sa(2,1) double %zapisany w i-tym LUW
        Sb(2,1) double %zapisany w j-tym LUW
    end
    methods
        function obj = pin(connection,Sa,Sb)
            if connection(1) == connection(2)
                throw(MException('MyComponent:sameElements','Nie można połączyć członu z nim samym'))
            end
            obj.connection = connection;
            obj.Sa = Sa;
            obj.Sb = Sb;
        end
    end
end