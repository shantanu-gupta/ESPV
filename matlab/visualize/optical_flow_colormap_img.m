function [img] = optical_flow_colormap_img(L)
%OPTICAL_FLOW_COLORMAP_IMG
    if nargin < 1 || isempty(L)
        L = 200;
    end
    % x increases left to right
    % y _up_ to _down_
    if mod(L, 2) == 1
        L = L + 1;
    end
    [xx, yy] = meshgrid(-L/2:L/2, -L/2:L/2);
    img = flowToColor(cat(3, xx, yy));
end

