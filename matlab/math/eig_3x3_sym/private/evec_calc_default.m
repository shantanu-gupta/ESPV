function [evec] = evec_calc_default(A11, A12, A13, A22, A23, evalue)
%EVEC_CALC_DEFAULT
    % See Kopp (2008) section 3.2
    m11 = A11 - evalue;
    m22 = A22 - evalue;
    % m33 = A33 - evalue;
    m21 = A12;
    m31 = A13;
    m32 = A23;

    [v1, v2, v3] = cross_product(m11, m21, m31, m21, m22, m32);
    % V = cross(cat(4, m11, m21, m31), cat(4, m21, m22, m32), 4);
    % v1 = V(:,:,:,1);
    % v2 = V(:,:,:,2);
    % v3 = V(:,:,:,3);
    % v1 = m21 .* m32 - m31 .* m22;
    % v2 = m31 .* m21 - m11 .* m32;
    % v3 = m11 .* m22 - m21 .* m21;

    % detect cases where columns 1 and 2 are linearly dependent
    scale_12 = cat(4, ...
                    m11 ./ m21, ...
                    m21 ./ m22, ...
                    m31 ./ m32);
    mean_scale_12 = mean(scale_12, 4, 'omitnan');
    tol = 1e-3;
    diff_scale_12 = (scale_12 - mean_scale_12) ./ mean_scale_12;
    dep_flags = all((abs(diff_scale_12) < tol) & ~isnan(diff_scale_12), 4);        
    mu12_dep = mean_scale_12(dep_flags);
    denom_factor12 = 1 ./ sqrt(1 + (mu12_dep .^ 2));
    clear('m11', 'm21', 'm31', 'm22', 'm32');
    clear('scale_12', 'mean_scale_12', 'diff_scale_12');
    
    v1(dep_flags) = denom_factor12;
    v2(dep_flags) = -mu12_dep .* denom_factor12;
    v3(dep_flags) = 0;
    clear('dep_flags', 'denom_factor', 'mu_dep');

    % normalize
    s = max(eps, sqrt(v1.^2 + v2.^2 + v3.^2));
    v1 = v1 ./ s;
    v2 = v2 ./ s;
    v3 = v3 ./ s;
    clear('s');

    evec = cat(4, v1, v2, v3); 
end
