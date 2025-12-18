function B_grad_tot = Bgrad_hard_at_point(hardSegs, P)
% Bgrad_hard_at_point
% 由一块分割好的硬磁体在空间一点 P 产生的总磁场梯度 ∇B
%
% 输入:
%   hardSegs - struct 数组，包含 .coord, .dm
%   P        - 3x1 矢量，场点位置
%
% 输出:
%   B_grad_tot - 3x3 矩阵，磁感应强度的梯度（你 DB_grad 的输出格式）

    hardList = reshape(hardSegs, [], 1);
    B_grad_tot = zeros(3,3);

    for ih = 1:numel(hardList)
        Q  = hardList(ih).coord;
        dm = hardList(ih).dm;
        B_grad = DB_grad(dm, Q, P);  % 你已经写好的函数
        B_grad_tot = B_grad_tot + B_grad;
    end
end