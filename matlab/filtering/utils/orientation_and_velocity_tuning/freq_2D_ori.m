function [f] = freq_2D_ori(f0, thd)
%FREQ_2D_ORI
    f = f0 * [cosd(thd) sind(thd)];
end
