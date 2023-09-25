function [Vm, Wm] = vel_scalecomb_max(V, W)
%VEL_SCALECOMB_MAX
    Vmat = cat(5, V{:});    % H x W x 2 x N x S
    Wmat = cat(4, W{:});    % H x W x N x S
    Vmag = squeeze(vecnorm(Vmat, 2, 3));    % H x W x N x S
    [~, smax] = max(Vmag .* Wmat, [], 4);   % H x W x N
    Vmx = zeros(size(Vmat, [1 2 4]), 'like', Vmat);
    Vmy = zeros(size(Vmat, [1 2 4]), 'like', Vmat);
    Wm = zeros(size(Wmat, [1 2 3]), 'like', Wmat);
    for s = 1:numel(V)
        Vs = V{s};
        Ws = W{s};
        i_s = smax == s;
        Vsx = squeeze(Vs(:,:,1,:));
        Vsy = squeeze(Vs(:,:,2,:));
        Vmx(i_s) = Vsx(i_s);
        Vmy(i_s) = Vsy(i_s);
        Wm(i_s) = Ws(i_s);
    end
    Vm = cat(3, permute(Vmx, [1 2 4 3]), permute(Vmy, [1 2 4 3]));
end

