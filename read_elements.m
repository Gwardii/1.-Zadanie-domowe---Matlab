function elements = read_elements(path)
A = readmatrix(path,'Range','A1');
for i = 1:height(A)
    elements(i) = element2D(A(i,1:2));
    for j = 3:2:width(A)
        if isnan(A(i,j))
            break
        end
        elements(i).add_vertice(A(i,[j,j+1])');
    end
end