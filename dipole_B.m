function B = dipole_B(dm, Q, P)
% dipole_B
% 由磁偶极矩 dm（位置 Q）在点 P 产生的磁感应强度 B（dipole model）
%
% 输入:
%   dm - 3x1 矢量，磁偶极矩
%   Q  - 3x1 矢量，dipole 位置
%   P  - 3x1 矢量，场点位置
%
% 输出:
%   B  - 3x1 矢量，磁感应强度 [T]

    mu0 = 1.256637e-6;
    k   = mu0 / (4*pi);

    r = P - Q;
    r2 = sum(r.^2);
    r_norm = sqrt(r2);

    if r_norm < 1e-9
        B = [0;0;0];
        return;
    end

    B = k * ( 3*r*(dm.'*r)/r_norm^5 - dm/r_norm^3 );
end