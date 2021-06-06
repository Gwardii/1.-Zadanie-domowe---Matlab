function M_result = mass_matrix(varargin)
persistent M
if ~isempty(varargin)
    elements = varargin{1};
    iter = 1;
    M = zeros(3*width(elements)-3);
    for element = elements(2:end)
        M(iter:iter+1,iter:iter+1) = eye(2)*element.mass;
        M(iter+2,iter+2) = element.moment_of_inertia;
        iter = iter + 3;
    end
end
M_result = M;
end