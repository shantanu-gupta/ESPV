function [smorid, smphid] = smoothorient_3D(orid, phid, sigma)
%SMOOTHORIENT_3D
    % expects ori, phi in degrees
    rt = imgaussfilt3(cosd(phid), sigma);
    rx = imgaussfilt3(sind(phid) .* cosd(orid), sigma);
    ry = imgaussfilt3(sind(phid) .* sind(orid), sigma);
    rs = hypot(rx, ry);

    smphid = round(acotd(rt ./ (eps + rs)));
    smorid = round(atan2d(ry, rx));
    % when phi is negative we need to make it positive, and rotate ori by
    % 180 degrees (opposite direction)
    neg_phid = smphid < 0;
    smphid(neg_phid) = -smphid(neg_phid);
    % this still means that eori will not be > 360 anywhere
    smorid(neg_phid) = smorid(neg_phid) + 180;
    % now we can handle negative orientations (we just add 360)
    neg_orid = smorid < 0;
    smorid(neg_orid) = smorid(neg_orid) + 360;
end

