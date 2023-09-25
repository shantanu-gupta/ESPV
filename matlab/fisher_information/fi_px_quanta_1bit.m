function [In] = fi_px_quanta_1bit(f)
%FI_PX_QUANTA_1BIT
    p = ppd(f);
    In = (1 - p) ./ p;
end

