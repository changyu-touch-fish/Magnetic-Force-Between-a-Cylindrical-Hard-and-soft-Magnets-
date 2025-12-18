function [idx, centers] = voxelize_cylinder_idx(R, H, a, C)
% 返回 N×3 int32 idx，以及 N×3 double centers = C + idx*a

if nargin < 4, C = [0;0;0]; end
C = C(:).';

nx = ceil(R / a) + 1;
nz = ceil((H/2) / a) + 1;

ixs = int32(-nx:nx);
iys = int32(-nx:nx);
izs = int32(-nz:nz);

idx = zeros(0,3,'int32');
centers = zeros(0,3);

for ii = 1:numel(ixs)
    ix = ixs(ii); x = double(ix)*a;
    for jj = 1:numel(iys)
        iy = iys(jj); y = double(iy)*a;

        if x^2 + y^2 > R^2, continue; end

        for kk = 1:numel(izs)
            iz = izs(kk); z = double(iz)*a;
            if abs(z) > H/2, continue; end

            idx(end+1,:) = [ix,iy,iz]; %#ok<AGROW>
            centers(end+1,:) = C + [x,y,z]; %#ok<AGROW>
        end
    end
end
end