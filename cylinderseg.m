% This function is to segment the cylinder magnets into smaller units
function cells=cylinderseg(D, H, M_coordinate, M_unit, seg_trunk)
% basic parameters
    xc = M_coordinate(1);
    yc = M_coordinate(2);
    zc = M_coordinate(3);
    R  = D / 2;

% the index of each segments 
n1=seg_trunk(1);
n2=seg_trunk(2);
n3=seg_trunk(3);

% each segment geometry parameters
dTheta = 2*pi / n1;
dR = R/n2;
dZ = H/n3;

% Initialize the structure array, each include the coordinate and the magnetic moment
cells(n1, n2, n3) = struct('coord', [0 0 0]', 'dm', [0,0,0]', 'dv', 0);

% triple loop to generate each small unit.
for i_t = 1:n1
    % current unit angle
    theta_center = (i_t - 0.5) * dTheta;  % (0, 2π) uniform distribution

    for i_r = 1:n2
        % current unit r
        r_center = (i_r - 0.5) * dR;  % from [0, R] 
        % Convert to x, y offsets on a plane (relative to the center of the cylinder).
        dx = r_center * cos(theta_center);
        dy = r_center * sin(theta_center);

        for i_z = 1:n3
            % current unit height 
            z_center = zc - H/2 + (i_z - 0.5) * dZ;

            % coordinate of each segment
            x = xc + dx;
            y = yc + dy;
            z = z_center;

            % the volume of the segment
            dv = r_center*dTheta*dR*dZ;

            % write in the structure
            cells(i_t, i_r, i_z).coord = [x, y, z]';
            cells(i_t, i_r, i_z).dm = dv*M_unit;
            cells(i_t, i_r, i_z).dv = dv;
        end
    end
end

end