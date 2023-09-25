function [phid] = phid_vtuned(v)
%VTUNED_PHID
    % This angle is in frequency-domain, clock-wise with respect to the
    % positive f_t-axis
    phid = -acotd(v);
    phid(phid < 0) = phid(phid < 0) + 180;
end

