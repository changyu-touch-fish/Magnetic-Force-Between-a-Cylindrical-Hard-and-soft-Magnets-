function H = H_hard_at_point(hardSegs, P)
% H_hard_at_point
% 由一块分割好的硬磁体在空间一点 P 产生的磁场 H
%
% 输入:
%   hardSegs - struct 数组，包含 .coord, .dm
%   P        - 3x1 矢量，场点位置
%
% 输出:
%   H        - 3x1 矢量，磁场 [A/m]

    mu0 = 1.256637e-6;

    hardList = reshape(hardSegs, [], 1);
    Htmp = [0;0;0];

    for ih = 1:numel(hardList)
        Q  = hardList(ih).coord;
        dm = hardList(ih).dm;
        B  = dipole_B(dm, Q, P);
        Htmp = Htmp + B/mu0;
    end

    H = Htmp;
end
