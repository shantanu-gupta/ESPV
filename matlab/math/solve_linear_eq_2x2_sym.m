function [x1, x2, rel] = solve_linear_eq_2x2_sym(AtA_11, AtA_12, AtA_22, Atb_1, Atb_2, k)
%SOLVE_LINEAR_EQ_2X2_SYM
    if nargin < 6 || isempty(k)
        k = 1e-2;
    end

    determinant = (AtA_11 .* AtA_22) - (AtA_12 .* AtA_12);
    inv_AtA_11 = AtA_22;
    inv_AtA_12 = -AtA_12;
    inv_AtA_22 = AtA_11;

    x1 = inv_AtA_11 .* Atb_1 + inv_AtA_12 .* Atb_2;
    x2 = inv_AtA_12 .* Atb_1 + inv_AtA_22 .* Atb_2;

    x1 = x1 ./ (eps + determinant);
    x2 = x2 ./ (eps + determinant);

    if nargout > 2
        rel = determinant > k * ((AtA_11 + AtA_22) .^ 2);
    end
end

