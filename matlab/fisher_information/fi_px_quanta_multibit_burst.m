function [In] = fi_px_quanta_multibit_burst(f, K)
%FI_PX_QUANTA_MULTIBIT_BURST
    In = (1/K) * fi_px_quanta_1bit(f/K);
end

