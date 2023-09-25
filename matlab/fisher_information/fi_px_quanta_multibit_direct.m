function [In] = fi_px_quanta_multibit_direct(f, M)
%FI_PX_QUANTA_MULTIBIT_DIRECT
    u1 = poisscdf(M-2, f);              % Pr ((M-2)- | f), M-2 included
    u2 = poisspdf(M-1, f);              % Pr (M-1 | f)
    u3 = poisspdf(M, f);                % Pr (M | f)
    u4 = poisscdf(M-1, f, 'upper');     % Pr (M+ | f), M included

    In = (1 ./ max(eps, f)) .* (u1 - (M-1)*u2 + M * (u3 .* (1 + (u2 ./ max(eps, u4)))));
end

