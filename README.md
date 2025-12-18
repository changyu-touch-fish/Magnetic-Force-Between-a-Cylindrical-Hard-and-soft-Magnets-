# Magnetic Force Between a Cylindrical Hard Magnet and a Cylindrical Soft Magnet

This repository provides a self-contained MATLAB demo to compute the magnetic force exerted by a cylindrical hard magnet on a cylindrical soft magnet, including self-demagnetization of the soft magnet using a kernel lookup table.

The code is intended for research / academic use, where one needs a reliable and verifiable force calculation without relying on full FEM software.

✨ Features

✔ Hard magnet modeled as a collection of magnetic dipoles

✔ Soft magnet modeled with linear susceptibility and self-consistent demagnetization

✔ Demagnetization field computed via a precomputed kernel lookup table

✔ Force computed using the Kelvin force formulation

✔ Verified against analytical demagnetization factors for cylinders

✔ No external dependencies beyond MATLAB



Repository Structure
.
├── main_force_test.m                  % Example script (entry point)
├── force_hardCyl_on_softCyl.m         % Main force computation function
├── get_demag_operator_cached.m        % Cached demagnetization operator
├── assemble_demag_operator_array_idx.m% Kernel-based demag operator assembly
├── voxelize_cylinder_idx.m            % Voxelization of soft magnet
├── cylinderseg.m                      % Segmentation of hard magnet
├── H_hard_at_point.m                  % Magnetic field from hard magnet
├── Bgrad_hard_at_point.m              % Magnetic field gradient from hard magnet
├── kernel_array.mat                   % Precomputed demagnetization kernel
└── README.md


Physical Model Overview
Hard Magnet

Modeled as a uniformly magnetized cylinder

Discretized into small dipole elements

Generates an external magnetic field Hₑₓₜ and field gradient ∇B

Soft Magnet

Modeled as a linear magnetic material

Magnetization follows:
𝑀=𝜒(𝐻ext+𝐻demag)

Self-demagnetization field computed via a kernel-based operator:
𝐻demag=𝐴𝑀

This leads to the linear system:
(𝐼−𝜒𝐴)𝑀=𝜒𝐻ext

Force Calculation
The total force on the soft magnet is computed by integrating the Kelvin force density:
𝐹=∫(𝑀⋅∇)𝐵𝑑𝑉




Numerical Discretization
Soft Magnet Voxelization
The soft magnet is discretized into cubic voxels of edge length a
Each voxel is represented by:
An integer index (ix, iy, iz)
A physical center at (ix·a, iy·a, iz·a)
Important: voxel centers are defined at integer multiples of a, not (i+0.5)a
This convention is consistent with the kernel table and must not be changed.

Kernel Lookup Table
Stored in kernel_array.mat
Contains a 5D array:
TK(dx, dy, dz, i, j)
representing the demagnetization tensor between two voxel centers separated by
(dx·a, dy·a, dz·a)

