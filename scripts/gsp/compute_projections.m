function w = compute_projections(activation, eigenvectors)
%this function takes a vector of activation (1 x regions) and the
%eigenvectors of the structural matrix (regions x regions) and outputs the
%projections (coefficients) using the dot product
    
    w = zeros(1,length(activation));
    for i=1:length(activation)
        w(i) = dot(activation, eigenvectors(:, i));
    end

end

