function A = get_demag_operator_cached(idx, K)
% 缓存 demag operator A：只要体素集合 idx 和 kernel 元数据没变，就复用上次的 A。
%
% 说明：
% - 对于同一个圆柱尺寸/体素尺度 a，idx 不变 → A 不变
% - 硬磁怎么变、Hext 怎么变，都不影响 A

persistent last_key last_A

% 用 idx 的数量 + 包围盒 + kernel 范围 + TK 尺寸作为 key（足够稳且便宜）
idx_min = double(min(idx,[],1));
idx_max = double(max(idx,[],1));
tk_sz   = size(K.TK);

key = [ ...
    double(size(idx,1)), ...
    idx_min, idx_max, ...
    double(K.dx_min), double(K.dx_max), ...
    double(K.dy_min), double(K.dy_max), ...
    double(K.dz_min), double(K.dz_max), ...
    double(tk_sz(1)), double(tk_sz(2)), double(tk_sz(3)) ];

if ~isempty(last_A) && isequal(key, last_key)
    A = last_A;
    return;
end

A = assemble_demag_operator_array_idx(idx, K);

last_key = key;
last_A   = A;

end