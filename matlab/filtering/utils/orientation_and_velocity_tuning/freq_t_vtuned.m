function [ft] = freq_t_vtuned(fs, vn)
%VTUNED_FREQ_T
    assert((isscalar(fs) && isscalar(vn)) || (~isscalar(fs) && ~isscalar(vn)));
    ft = -dot(fs, vn);
end

