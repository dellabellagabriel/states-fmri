function M = vec2tri(vec)
%transforms a vector into a symmetric matrix

n_vec = length(vec);
n = (1+sqrt(1+8*n_vec))/2;

inds = find(triu(not(eye(n))));
M = zeros(n);
M(inds) = vec;
M = M+M';

end

