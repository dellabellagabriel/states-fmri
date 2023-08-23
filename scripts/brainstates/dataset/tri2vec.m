function vec = tri2vec(M)
%Takes a symmetric matrix and squeezes only
%the upper triangular part

n = size(M,1);

inds = find(triu(not(eye(n))));
vec = M(inds);

end