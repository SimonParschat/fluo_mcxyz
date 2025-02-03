home; clear
format compact
commandwindow


%%%% USER CHOICES <---------- you must specify -----
myname = 'skinvessel'; nm = 794;
%%%%


disp(sprintf('------ mcxyz %s -------',myname))

% Load header file
filename = sprintf('%s_H.mci',myname);
disp(['loading ' filename])
fid = fopen(filename, 'r');
A = fscanf(fid,'%f',[1 Inf])';
fclose(fid);

%% parameters
time_min = A(1);
Nx = A(2);
Ny = A(3);
Nz = A(4);
dx = A(5);
dy = A(6);
dz = A(7);
mcflag = A(8);
launchflag = A(9);
boundaryflag = A(10);
xs = A(11);
ys = A(12);
zs = A(13);
xfocus = A(14);
yfocus = A(15);
zfocus = A(16);
ux0 = A(17);
uy0 = A(18);
uz0 = A(19);
radius = A(20);
waist = A(21);
Nt = A(22);
j = 22;
for i=1:Nt
    j=j+1;
    muav(i,1) = A(j);
    j=j+1;
    musv(i,1) = A(j);
    j=j+1;
    gv(i,1) = A(j);
end

reportHmci(myname)

%% Load Ang
filename = sprintf('%s_Ang.bin',myname);
disp(['loading ' filename])
tic
    fid = fopen(filename, 'rb');
    Ang = fread(fid, [3, Nx*Ny], 'float');
    fclose(fid);
toc

[i,j,v] = find(Ang(1,:));
thetas = zeros(size(Ang(1,:)));
thetas(j) = Ang(3,j)./v;

f = figure;
f.Position = [300 100 800 800];

clf; subplot(3,1,[1,2]);
imagesc(reshape(thetas, Nx,Ny)*180.0/pi)
clim([0, 180])
colorbar
impixelinfo
pbaspect ([ 1 1 1])
width = round(radius/dx);
rectangle('Position', [Nx/2 - width, Ny/2 - width, 2*width, 2*width])
title(sprintf('Exiting angle of %f cm Thick phantom', Nz*dz))

thetas = reshape(thetas, Nx,Ny)*180.0/pi;

subplot(3,1,3);
histogram(thetas(Nx/2 - width:Nx/2 + width, Ny/2 - width:Ny/2 + width), 10:180)
title('Exit angle distribution in outlined rectangle')