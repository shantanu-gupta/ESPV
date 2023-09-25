function [evals, evecs] = eig_3x3_sym(A11, A12, A13, A22, A23, A33)
%EIG_3X3_SYM
    %     i use the formula in Smith (1961) "Eigenvalues of a symmetric 3x3
    %     matrix", Communications of the ACM.
    %     TODO: use formula in Kopp (2008) to avoid numerical issues?
    % 
    %     arguments are assumed to be 3D arrays
    %     evals(:,:,:,1) has the max eigenvalue, evecs(:,:,:,:,1) corresponds
    %        ...      3    ...   min        ...                3      ...
    %
    m = (1/3) * (A11 + A22 + A33);
    A11_mm = A11 - m;
    A22_mm = A22 - m;
    A33_mm = A33 - m;

    p = (1/6) * (A11_mm.^2 + A22_mm.^2 + A33_mm.^2 ...
                + 2*(A12.^2 + A13.^2 + A23.^2));
    q = (1/2) * (A11_mm .* (A22_mm .* A33_mm - (A23.^2)) ...
                - A12 .* (A12.*A33_mm - A13.*A23) ...
                + A13 .* (A12.*A23 - A13.*A22_mm));
    clear('A11_mm', 'A22_mm', 'A33_mm');

    u = max(0, p.^3 - q.^2);    % this is shifty but maybe okay
    phi = (1/3) * atan(sqrt(u) ./ (q + eps));
    clear('q', 'u');

    negphi = phi < 0;
    phi(negphi) = phi(negphi) + pi;
    sqrtp = sqrt(p);
    clear('p', 'negphi');

    cp = cos(phi);
    s3sp = sqrt(3) * sin(phi);
    p1 = sqrtp .* cp;
    p2 = sqrtp .* s3sp;
    clear('sqrtp', 'cp', 's3sp', 'phi');

    evals1_in = m + 2*p1;
    evals2_in = m - (p1 + p2);
    evals3_in = m - (p1 - p2);
    clear('m', 'p1', 'p2');

    evals1 = max(evals1_in, max(evals2_in, evals3_in));
    evals3 = min(evals1_in, min(evals2_in, evals3_in));
    evals2 = (evals1_in + evals2_in + evals3_in) - (evals1 + evals3);
    evals = cat(4, evals1, evals2, evals3);
    clear('evals1', 'evals2', 'evals3', 'evals1_in', 'evals2_in', 'evals3_in');

    % this shouldn't be necessary but maybe is
    evals = max(0, evals);

    if nargout > 1
        evec1 = evec_calc_default(A11, A12, A13, A22, A23, evals(:,:,:,1));

        % 2nd eigenvector proceeds similarly at first
        evec2 = evec_calc_default(A11, A12, A13, A22, A23, evals(:,:,:,2));

        % but for degenerate eigenvalues we need to do something else
        diff_scale_12 = (evals(:,:,:,1) - evals(:,:,:,2)) ./ max(eps, evals(:,:,:,1));
        tol = 0.05;
        degen_flags = diff_scale_12 < tol;
        clear('diff_scale_12', 'tol');

        evec2_alt = cross(evec1, cat(4, A11 - evals(:,:,:,1), ...
                                        A12, ...
                                        A13), ...
                          4);
        evec2_alt = evec2_alt ./ max(eps, vecnorm(evec2_alt, 2, 4));
        evec2 = evec2 .* (1 - degen_flags) + evec2_alt .* degen_flags;
        clear('degen_flags', 'evec2_alt');

        evec3 = cross(evec1, evec2, 4);

        evecs = cat(5, evec1, evec2, evec3);
    end
end
