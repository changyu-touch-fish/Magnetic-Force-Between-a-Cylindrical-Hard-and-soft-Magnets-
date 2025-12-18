function A = assemble_demag_operator_array_idx(idx, K)
% assemble_demag_operator_array_idx
%
% 使用 kernel lookup table 组装 demag operator A，使得：
%   vec(H_demag) = A * vec(M)
%
% 输入：
%   idx : N×3 int32，体素格点索引
%   K   : struct，包含
%         K.TK     : [nx ny nz 3 3] double
%         K.dx_min, K.dx_max
%         K.dy_min, K.dy_max
%         K.dz_min, K.dz_max
%
% 输出：
%   A   : (3N × 3N) sparse matrix
%
% 设计原则：
%   - kernel 覆盖范围检查只做一次（入口）
%   - for 循环内不做任何 if / 边界判断（极致性能）

%% ==================== 0) 一次性 kernel 覆盖范围检查 ====================

% idx 在三个方向上的最小 / 最大
ix_min = double(min(idx(:,1)));
ix_max = double(max(idx(:,1)));

iy_min = double(min(idx(:,2)));
iy_max = double(max(idx(:,2)));

iz_min = double(min(idx(:,3)));
iz_max = double(max(idx(:,3)));

% 可能出现的最小 / 最大相对位移
dx_min_req = ix_min - ix_max;   % 最负
dx_max_req = ix_max - ix_min;   % 最大

dy_min_req = iy_min - iy_max;
dy_max_req = iy_max - iy_min;

dz_min_req = iz_min - iz_max;
dz_max_req = iz_max - iz_min;

% 检查是否落在 kernel table 支持范围内
if dx_min_req < K.dx_min || dx_max_req > K.dx_max || ...
   dy_min_req < K.dy_min || dy_max_req > K.dy_max || ...
   dz_min_req < K.dz_min || dz_max_req > K.dz_max

    error(['assemble_demag_operator_array_idx: kernel range insufficient.\n' ...
           'Required: dx=[%d,%d], dy=[%d,%d], dz=[%d,%d]\n' ...
           'Kernel  : dx=[%d,%d], dy=[%d,%d], dz=[%d,%d]'], ...
           dx_min_req, dx_max_req, ...
           dy_min_req, dy_max_req, ...
           dz_min_req, dz_max_req, ...
           K.dx_min, K.dx_max, ...
           K.dy_min, K.dy_max, ...
           K.dz_min, K.dz_max);
end

%% ==================== 1) 组装 demag operator ====================

TK  = K.TK;
dx0 = K.dx_min;
dy0 = K.dy_min;
dz0 = K.dz_min;

N = size(idx,1);

% 预估非零元数（每一对体素贡献 3×3 = 9 个）
nnz_est = 9 * N * N;
I = zeros(nnz_est,1,'int32');
J = zeros(nnz_est,1,'int32');
V = zeros(nnz_est,1);
p = 0;

for alpha = 1:N
    ia = 3*(alpha-1);

    ixa = idx(alpha,1);
    iya = idx(alpha,2);
    iza = idx(alpha,3);

    for beta = 1:N
        ib = 3*(beta-1);

        dx = int32(ixa - idx(beta,1));
        dy = int32(iya - idx(beta,2));
        dz = int32(iza - idx(beta,3));

        % 映射到 kernel table 下标
        ix = int32(dx - dx0 + 1);
        iy = int32(dy - dy0 + 1);
        iz = int32(dz - dz0 + 1);

        % 这里不再做任何越界检查（已在入口统一保证）
        T = squeeze(TK(ix, iy, iz, :, :));  % 3×3 demag tensor

        for i = 1:3
            Ii = ia + i;
            for j = 1:3
                p = p + 1;
                I(p) = Ii;
                J(p) = ib + j;
                V(p) = T(i,j);
            end
        end
    end
end

A = sparse(double(I(1:p)), double(J(1:p)), V(1:p), 3*N, 3*N);

end