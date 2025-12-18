%% ===================== main_force_test.m =====================
% Example script:
%   Compute magnetic force exerted by a cylindrical hard magnet
%   on a cylindrical soft magnet using kernel-based self-demag.
% Requirements:
%   - kernel_array.mat
%   - force_hardCyl_on_softCyl.m
%   - cylinderseg.m
%   - voxelize_cylinder_idx.m
%   - assemble_demag_operator_array_idx.m
%   - get_demag_operator_cached.m
%   - H_hard_at_point.m
%   - Bgrad_hard_at_point.m
%   - DB_grad.m
%   - dipole_B.m

clear; clc;

%% ===================== 1) load kernel =====================
% kernel_array.mat should contain:
%   K.TK, K.dx_min, K.dx_max, K.dy_min, K.dy_max, K.dz_min, K.dz_max
K = load('kernel_array.mat');

fprintf('Kernel loaded.\n');
fprintf('Kernel range: dx=[%d,%d], dy=[%d,%d], dz=[%d,%d]\n', ...
    K.dx_min, K.dx_max, K.dy_min, K.dy_max, K.dz_min, K.dz_max);
fprintf('Kernel size: %d x %d x %d x 3 x 3\n', ...
    size(K.TK,1), size(K.TK,2), size(K.TK,3));

%% ===================== 2) hard magnet parameters =====================
% Cylindrical hard magnet
hardD = 4.0e-3;                 % diameter [m]
hardH = 7.0e-3;                 % height   [m]
hardC = [0; 0; 0e-3];         % center position [m]
hardM_unit = [0; 0; 0.98e6];     % magnetization [A/m] (along +z)

% segmentation of hard magnet (theta, r, z)
seg_trunk = [36, 10, 10];

%% ===================== 3) soft magnet parameters =====================
% Cylindrical soft magnet
softD = 2.0e-3;                 % diameter [m]
softH = 1.2e-3;                 % height   [m]
softC = [0; 0; 6.08e-3];        % center position [m]
chi   = 1000;                   % linear susceptibility; a large number would be enough

% voxel size
a = max([softD,softH])./20;                     % voxel edge length [m]; make sure softD/a<K.dx_max and softH/a<K.dx_max

%% ===================== 4) compute force =====================
fprintf('\nComputing magnetic force...\n');
tic;
[F_total, Msoft] = force_hardCyl_on_softCyl( ...
    hardD, hardH, hardC, hardM_unit, seg_trunk, ...
    softD, softH, softC, chi, ...
    a, K);
t_elapsed = toc;

%% ===================== 5) output =====================
fprintf('\n===== Results =====\n');
fprintf('Total force [N]:\n');
fprintf('  Fx = %+ .4e\n', F_total(1));
fprintf('  Fy = %+ .4e\n', F_total(2));
fprintf('  Fz = %+ .4e\n', F_total(3));
fprintf('Elapsed time: %.3f s\n', t_elapsed);
fprintf('\nDone.\n');