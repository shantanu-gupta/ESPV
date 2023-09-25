function [smorid] = smoothorient(orid, sigma)
%SMOOTHORIENT
    % expects ori in degrees
    cosori = imgaussfilt(cosd(orid), sigma);
    sinori = imgaussfilt(sind(orid), sigma);
    smorid = atan2d(sinori, cosori);
    neg = smorid < 0;
    smorid(neg) = smorid(neg) + 180;
end

