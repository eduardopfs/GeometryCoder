%Putting the source folder in the matlab path.

clc

version = 'SPL';
disp(['Initializing Point Cloud Geometry coder version ' version ''])

home = pwd;
src = [home '\' version];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home '\' version '\ArithmeticCoding'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home '\' version '\Structs'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home '\' version '\Bitstream'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home '\' version '\Encoder'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home '\' version '\Decoder'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home '\' version '\Utils'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

clear home;
clear src;

cd(version);
