Magnetic Force Between a Cylindrical Hard Magnet and a Cylindrical Soft Magnet

This repository provides a self-contained MATLAB demo to compute the magnetic force exerted by a cylindrical hard magnet on a cylindrical soft magnet, including self-demagnetization of the soft magnet using a kernel lookup table.

The code is intended for research / academic use, where one needs a reliable and verifiable force calculation without relying on full FEM software.

✨ Features

✔ Hard magnet modeled as a collection of magnetic dipoles

✔ Soft magnet modeled with linear susceptibility and self-consistent demagnetization

✔ Demagnetization field computed via a precomputed kernel lookup table

✔ Force computed using the Kelvin force formulation

✔ Verified against analytical demagnetization factors for cylinders

✔ No external dependencies beyond MATLAB