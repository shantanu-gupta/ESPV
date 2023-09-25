function [dc] = dircosd_3D(phid, thetad)
%DIRCOS_3D
    phid = reshape(phid, [], 1);
    thetad = reshape(thetad, [], 1);
    dc = single([sind(phid).*cosd(thetad), sind(phid).*sind(thetad), cosd(phid)]);
end

