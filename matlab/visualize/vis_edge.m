function [evis] = vis_edge(estr, thicken, prctile_lim)
%EDGE_VIS
    if nargin < 2 || isempty(thicken)
        thicken = false;
    end
    if nargin < 3
        prctile_lim = [75 97];
    end

    if size(estr, 3) > 1
        evis = zeros(size(estr), 'like', estr);
        for n = 1:size(estr,3)
            evis(:,:,n) = vis_edge(estr(:,:,n), thicken, prctile_lim);
        end
        return;
    end

    if isfloat(estr)
        if ~isempty(prctile_lim)
            lo = prctile(estr, min(prctile_lim(:)), 'all');
            hi = prctile(estr, max(prctile_lim(:)), 'all');
        else
            lo = min(estr(:));
            hi = max(estr(:));
        end
        estr = rescale(estr, 'InputMin', lo, 'InputMax', hi);
    end

    if thicken
        estr = ordfilt2(estr, 9, true([3 3]));
    end

    if isa(estr, 'uint8')
        evis = 255 - estr;
    else
        evis = 1 - estr;
    end

    % border
    evis(:,1,:) = 0;
    evis(:,end,:) = 0;
    evis(1,:,:) = 0;
    evis(end,:,:) = 0;
end
