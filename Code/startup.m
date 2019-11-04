%Putting the source folder in the matlab path.
clc

version = 'SPL';
disp(['Initializing Point Cloud Geometry coder version ' version ''])

% Check if this is a Window$ or a Unix machine because paths
% work diffferently
comp = computer();
if isequal(comp, 'PCWIN64')
    bar = '\';
else
    bar = '/';
end

% Build folder to add to path.
home = pwd;
src = [home bar version];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home bar version bar 'ArithmeticCoding'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home bar version bar 'Structs'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home bar version bar 'Bitstream'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home bar version bar 'Encoder'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home bar version bar 'Decoder'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

src = [home bar version bar 'Utils'];
disp(['Adding ' src ' to the Matlab Path'])
addpath(src);

clear home;
clear src;

% Move workspace to where code is.
cd(version);
