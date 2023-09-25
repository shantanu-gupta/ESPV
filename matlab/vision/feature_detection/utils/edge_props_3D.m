function [estr, eori, ephi, evn] = edge_props_3D(ex, ey, et)
%EDGE_PROPS_3D Get edge strengths and standardized 3D orientations
    % Spatial orientations need to be in range (0, 360) in 3D because this
    % directly gives the normal direction -- messing around with this will
    % throw off the normal as well making NMS much harder
    eori = round(atan2d(ey, ex));

    es = hypot(ex, ey); % "spatial"
    estr = hypot(es, et);

    % Temporal orientation (phi) is limited to the range (0, 90), however.
    % This is enough to handle the redundancy between opposite gradient
    % directions (but the code has to be careful, as done below).
    % (+eps prevents divzero problems)
    evn = -et ./ max(eps('single'), es);
    ephi = round(acotd(-evn));

    % when phi is negative we need to make it positive, and rotate ori by
    % 180 degrees (opposite direction)
    neg_phi = ephi < 0;
    ephi(neg_phi) = -ephi(neg_phi);
    evn(neg_phi) = -evn(neg_phi);
    % this still means that eori will not be > 360 anywhere
    eori(neg_phi) = eori(neg_phi) + 180;

    % now we can handle negative orientations (we just add 360)
    neg_ori = eori < 0;
    eori(neg_ori) = eori(neg_ori) + 360;
end
