# Fluorescence mcxyz: fluo_mcxyz
Modification of the mcxyz.c simulation software by by Steven Jacques, Ting Li, Scott Prahl. Attempting to simulate fluorescence from tumor tissue at depth in various human tissues.

# Photon propagation
### 1. Move photon
    Step size is determined by:

$$s=\frac{-\log(rand[0,1])}{\mu_s}$$

    - If new position is in same voxel:
        absorb and set step size to 0.
$$absorb = W\cdot(1-e^{\mu_a \cdot s})$$
    - else:
        Step to voxel boundary and absorb.
        Step*mu_s is subtracted from remaining step size.
        If remaining step size is < 1e-7, set to 0.
        Check if photon is at boundary, terminate if condition.

### 2. Scatter photon
    Henyey-Greenstein scattering function [omlc.org](https://omlc.org/classroom/ece532/class3/hg.html).:

$$ p(\cos(\theta)) = \frac{1}{2} \frac{1-g^2}{(1+g^2-2g\cos(\theta))^{3/2}}$$
    then,
$$\int_{-1}^1 p(\cos(\theta))d(\cos(\theta)) = 1.$$
$$\int_{-1}^1 p(\cos(\theta))\cos(\theta)d(\cos(\theta)) = g.$$

    Calculating cos(theta) from,

$$ t = \frac{1.0 - g*g}{1.0 - g + 2*g*rnd}$$

$$\cos(\theta) = \frac{1.0 + g*g - t*t}{2.0*g}$$

    Psi is randomly chosen from [0,2pi].
    Trajectories are updated by these theta and psi angles.

### 3. Survival roulette
    If photon weight is below threshold (0.01),
    90% chance to kill photon,
    10% chance to increase photon weight by 1/chance (1/0.1).


### 4. Data aquisition
    - Absorption 
    Every time weight is absorbed in a voxel we add the deposited weight to corresponding voxel in Absorption matrix A.
    - Fluence
    Absorption matrix A can be modified to find the fluence matrix F.

$$ F_{i,j,k} = \frac{A}{\Delta x \cdot \Delta y \cdot \Delta z \cdot N_{photons} \cdot (\mu_a)_{i,j,k}} $$

    - Angle
    from photon trajectory vector u, (ux, uy, uz)
    Created an angle matrix containing 3 values for each voxel,
    1. # photons terminated in that voxel.
    2. Phi calculated from conditions on arctan(uy/ux) [wikipedia](https://en.wikipedia.org/wiki/Spherical_coordinate_system#Coordinate_system_conversions)
    3. Theta from arccos(uz/r) (r=0?)
   

# Creating volume
    Defining binsize and # bins along each axis to create voxels.
    Every voxel in the volume gets an integer value which defines the tissue type stored in a tissue list containing the optical properties.
### Tissue list
    Simple list for associating optical properties to voxels in tissue volume.
|index|name|mu_a|mu_s|g|
|-|-|-|-|-|
|1|breast|0.6|100/(1-g)|0.9|
|2|tumor|0.9|150/(1-g)|0.9|

# Source construction
### 0. Uniform beam:
    Given a radius, set the photon source positions randomly within radius at source depth (zs).
    Can change 'divergence' of beam by setting the 'waist' of beam at specified focus depth.
### 1. Gaussian:
    Currently not implemented.
### 2. Isotropic point:
    Forward angle theta calculated from,
        cos(theta) = rand[0,1]
        sin(theta) = sqrt(1-cos(theta)^2)
    Psi is just rand[0,2pi].
### 3. Collimated rectangular source
    xs, ys are defined by random values in the interval [-radius, radius] around center location.
    trajectory is [0,0,1] only along z-direction.

### 4. Rectangular isotropic source
    Source locations are same as for collimated rectangle. Trajectory is defined same as for isotropic point, by cos(theta) and psi angles.

