function DB_grad = DB_grad(dm,Q,P)
% this function is to calculate the magnetic field gradient produced by a magnetic dipole at Q on a specific point P
% dm is the magnetic moment of the magnetic dipole
% Q is the coordinate of the magnetic dipole
% P is the coordinate of the testing point
% the magnetic constant u0, H/m

u0=1.256637*10^(-6);
k=u0/(4*pi);

% the formula to calculate the magnetic field based on the dipole model
r = P-Q;
r2 = dot(r,r);
if r2 < 1e-9
    DB_grad = zeros(3); 
    return;
end

e = 1e-6; 
r_dy = r+[0,e,0]';
r_dz = r+[0,0,e]';

dB=k*(3*r*(dm'*r)./(r(1)^2+r(2)^2+r(3)^2)^(5/2)-dm./(r(1)^2+r(2)^2+r(3)^2)^(3/2));
dB_dz=k*(3*r_dz*(dm'*r_dz)./(r_dz(1)^2+r_dz(2)^2+r_dz(3)^2)^(5/2)-dm./(r_dz(1)^2+r_dz(2)^2+r_dz(3)^2)^(3/2));
dB_dy=k*(3*r_dy*(dm'*r_dy)./(r_dy(1)^2+r_dy(2)^2+r_dy(3)^2)^(5/2)-dm./(r_dy(1)^2+r_dy(2)^2+r_dy(3)^2)^(3/2));
Bzx = (dB_dz(1)-dB(1))/e; Bzy = (dB_dz(2)-dB(2))/e; Bzz = (dB_dz(3)-dB(3))/e;
Byy = (dB_dy(2)-dB(2))/e; Byx = (dB_dy(1)-dB(1))/e; 

DB_grad = [-Bzz-Byy,Byx, Bzx; Byx, Byy, Bzy; Bzx, Bzy, Bzz];

end

