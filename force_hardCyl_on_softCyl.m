function [F_total, Msoft] = force_hardCyl_on_softCyl( ...
    hardD, hardH, hardC, hardM_unit, seg_trunk, ...
    softD, softH, softC, chi, ...
    a, K)
% 计算圆柱硬磁对圆柱软磁的总磁力（含 kernel self-demag，自洽线性解）
% 输入：
%   hardD, hardH        硬磁直径/高度
%   hardC               硬磁中心 [3x1]
%   hardM_unit          硬磁磁化强度向量 [3x1], A/m
%   seg_trunk           硬磁分割 [nTheta nR nZ]
%
%   softD, softH        软磁直径/高度
%   softC               软磁中心 [3x1]
%   chi                 软磁线性磁化率
%
%   a                   软磁体素边长
%   K                   kernel struct: K.TK, K.dx_min/max, K.dy_min/max, K.dz_min/max

% 输出：
%   F_total             1x3 总磁力 [N]
%   Msoft               Nx3 每个软磁体素的磁化强度 [A/m]

%% 1) 硬磁分割成 dipole 单元
hardSegs = cylinderseg(hardD, hardH, hardC(:), hardM_unit(:), seg_trunk);

%% 2) 软磁体素化：idx 用于查表，centers 用于算 Hext/∇B
Rsoft = softD/2;
[idx, centers] = voxelize_cylinder_idx(Rsoft, softH, a, softC(:)); 
N  = size(idx,1);
dV = a^3;

%% 3) demag operator A（只与 idx 和 K 有关，可缓存）
A = get_demag_operator_cached(idx, K);

%% 4) 计算外场 Hext（硬磁在每个体素中心产生的 H）
Hext = zeros(N,3);
for i = 1:N
    Hext(i,:) = H_hard_at_point(hardSegs, centers(i,:).').';
end

%% 5) 自洽线性方程组：(I - chi*A) M = chi*Hext
b   = chi * reshape(Hext.', 3*N, 1);
LHS = speye(3*N) - chi * A;

Mvec  = LHS \ b;                 % 3N×1
Msoft = reshape(Mvec, 3, N).';   % N×3 (A/m)

%% 6) 力积分：F = Σ (∇B_hard(Pi) * Mi) dV
F = zeros(3,1);
for i = 1:N
    G = Bgrad_hard_at_point(hardSegs, centers(i,:).'); % 3×3, ∇B (T/m)
    F = F + (G * Msoft(i,:).') * dV;                   % N
end

F_total = F(:).';

end