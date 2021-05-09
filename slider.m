classdef slider < pin
    properties
        fi0(1,1) double %kąt między układami współrzędnych związanymi z członami
        v(2,1) double %wektor prostopadły do osi przesuwu opisany w j-tym LUW
    end
    methods
        function obj = slider(connection,vertices,v,fi0)
            obj@pin(connection,vertices);
            obj.fi0 = fi0;
            if norm(v) == 0
                throw(MException('MyComponent:zeroNormVector','Wektor v nie może być zerowy'))
            end
            obj.v = v;
        end
    end
end    