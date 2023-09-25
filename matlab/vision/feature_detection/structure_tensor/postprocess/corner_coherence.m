function [coh] = corner_coherence(lam2, lam3)
%CORNER_COHERENCE
%   Follows edge_coherence
%   Assume lam2 > lam3
    coh = (lam2 - lam3) ./ max(eps('single'), lam2 + lam3);
end

