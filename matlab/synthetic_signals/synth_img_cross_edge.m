function [S, emap] = synth_img_cross_edge(L, theta, c, alpha, center)
%GEN_CROSS_EDGE
    if nargin < 5
        center = [0 0];
    end
    S = zeros([L L]);
    xv = range_zero_centered(L);
    [xx, yy] = meshgrid(xv, xv);
    angl = atan2d(yy - center(2), xx - center(1));
    theta1 = theta;
    if theta1 > 0
        theta2 = theta1 - 90;
    else
        theta2 = theta1 + 90;
    end
    if theta1 == pi/2
        z1 = and(angl < 90-theta1, angl >= -90 - theta1);
    else
        z1 = and(angl <= 90-theta1, angl > -90 - theta1);
    end
    if theta2 == pi/2
        z2 = and(angl < 90-theta2, angl >= -90 - theta2);
    else
        z2 = and(angl <= 90-theta2, angl > -90 - theta2);
    end
    S((z1 & z2) | ~(z1 | z2)) = c * (1 + alpha);
    S((z1 & ~z2) | (~z1 & z2)) = c * (1 - alpha);

    emap1 = abs((xx - center(1)) * cosd(theta1) - (yy - center(2)) * sind(theta1)) <= 0.5;
    emap2 = abs((xx - center(1)) * cosd(theta2) - (yy - center(2)) * sind(theta2)) <= 0.5;
    emap = emap1 | emap2;
end

