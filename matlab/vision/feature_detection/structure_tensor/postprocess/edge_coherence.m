function [coh] = edge_coherence(lam1, lam2)
%EDGE_COHERENCE
%   Follows Unser's group's papers
%   Assume lam1 > lam2
    coh = (lam1 - lam2) ./ max(eps('single'), lam1 + lam2);
end

