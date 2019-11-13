%Script scriptRunDecoder
%
%  This script decodes all files in the dataset.
%  All binary files are provided.
%  To run this script, you must first write the workspaceFolder as the
%  basis Folder where the data is kept.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% 29/10/2019

%Change this to reflect your system
encodedDatasetFolder = 'C:\eduardo\Dropbox\PointCloud_Geometry\Public\EncodedDataset\';

k = 0;

k = k + 1;
%Andrew
sequence{k}        = 'andrew';
name{k}            = 'frame';
workspaceFolder{k} = [encodedDatasetFolder 'andrew9\'];
frameStart{k}      = 0;
frameEnd{k}        = 317;

k = k + 1;
%David
sequence{k}        = 'david';
name{k}            = 'frame';
workspaceFolder{k} = [encodedDatasetFolder 'david9\'];
frameStart{k}      = 0;
frameEnd{k}        = 215;

k = k + 1;
%Phil
sequence{k}        = 'phil';
name{k}            = 'frame';
workspaceFolder{k} = [encodedDatasetFolder 'phil9\'];
frameStart{k}      = 0;
frameEnd{k}        = 244;

k = k + 1;
%Ricardo
sequence{k}        = 'ricardo';
name{k}            = 'frame';
workspaceFolder{k} = [encodedDatasetFolder 'ricardo9\'];
frameStart{k}      = 0;
frameEnd{k}        = 215;

k = k + 1;
%Sarah
sequence{k}        = 'sarah';
name{k}            = 'frame';
workspaceFolder{k} = [encodedDatasetFolder 'sarah9\'];
frameStart{k}      = 0;
frameEnd{k}        = 206;

k = k + 1;
%Longdress
sequence{k}        = 'longdress';
name{k}            = 'longdress_vox10_';
workspaceFolder{k} = [encodedDatasetFolder 'longdress\'];
frameStart{k}      = 1051;
frameEnd{k}        = 1350;

k = k + 1;
%Loot
sequence{k}        = 'loot';
name{k}            = 'loot_vox10_';
workspaceFolder{k} = [encodedDatasetFolder 'loot\'];
frameStart{k}      = 1000;
frameEnd{k}        = 1299;

k = k + 1;
%RedAndBlack
sequence{k}        = 'redandblack';
name{k}            = 'redandblack_vox10_';
workspaceFolder{k} = [encodedDatasetFolder 'redandblack\'];
frameStart{k}      = 1450;
frameEnd{k}        = 1749;

k = k + 1;
%Soldier
sequence{k}        = 'soldier';
name{k}            = 'soldier_vox10_';
workspaceFolder{k} = [encodedDatasetFolder 'soldier\'];
frameStart{k}      = 0536;
frameEnd{k}        = 0835;

N = k;
for k = 1:1:N
    for i = frameStart{k}:1:frameEnd{k}
        strNum = num2str(i);
        leadingZeros = char(zeros(1,4 - length(strNum)) + 48);
        filename = [name{k} '' leadingZeros '' strNum ''];
        
        binaryFile  = [filename '.bin'];
        outputPly   = ['dec_' filename '.ply'];
        
        %Decodes the file
        decodePointCloudGeometry(binaryFile, outputPly);        
    end
end