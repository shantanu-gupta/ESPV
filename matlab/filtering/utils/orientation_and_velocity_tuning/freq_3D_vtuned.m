function [f] = freq_3D_vtuned(f0, thd, v)
%FREQ_3D_VTUNED
    f = [freq_2D_ori(f0, thd) freq_t_vtuned(f0, v)];
end
