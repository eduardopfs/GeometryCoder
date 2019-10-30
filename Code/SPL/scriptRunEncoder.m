%Script scriptRunEncoder
%
%  This script encodes all files in the JPEG Pleno dataset.
%  The JPEG Pleno dataset can be downloaded at:
%     https://jpeg.org/plenodb/
%  Both the Microsoft Voxelized Upper Bodies [1] dataset and the 
%  8i Voxelized Full Bodies [2] dataset can be encoded.
%  Note that the 9 bits sequences in the Upper Bodies Dataset run in a
%  reasonable time (around 120 seconds) in a good Desktop PC, but the 10
%  bits sequences take significantly longer (from 3000 to 6000 seconds,
%  depending on the number of voxels). 
%  To run this script, you must first write the datasetFolder as the
%  basis Folder where the data is kept.
%
%   [1] C. Loop, Q. Cai, S. O. Escolano, and P. A. Chou, "Microsoft 
%       Voxelized Upper Bodies – A Voxelized Point Cloud Dataset," ISO/IEC 
%       JTC1/SC29/WG11 m38673 ISO/IEC JTC1/SC29/WG1 M72012, Geneva, 
%       Switzerland, Tech. Rep., 2016.
%
%   [2] E. d’Eon, B. Harrison, T. Myers, and P. A. Chou, "8i Voxelized
%       Full Bodies, version 2 – A Voxelized Point Cloud Dataset," ISO/IEC
%       JTC1/SC29/WG11 m40059 ISO/IEC JTC1/SC29/WG1 M74006 Geneva, 
%       Switzerland, Tech. Rep., 2017.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
% 29/10/2019

%Change this to reflect your system
%The output folders must exist before the script is executed.
datasetFolder_UpperBodies = 'C:\eduardo\Sequences\PointClouds\UpperBodies\';
datasetFolder_FullBodies  = 'C:\eduardo\Sequences\PointClouds\FullBodies\';
outputFolder_UpperBodies  = 'C:\eduardo\workspace\results\UpperBodies\';
outputFolder_FullBodies   = 'C:\eduardo\workspace\results\FullBodies\';

k = 0;

k = k + 1;
%Andrew
sequence{k}        = 'andrew';
name{k}            = 'frame';
parentFolder{k}    = outputFolder_UpperBodies;
newFolder{k}       = 'andrew9';
dataFolder{k}      = [datasetFolder_UpperBodies 'andrew9\'];
workspaceFolder{k} = [outputFolder_UpperBodies 'andrew9\'];
frameStart{k}      = 0;
frameEnd{k}        = 317;

k = k + 1;
%David
sequence{k}        = 'david';
name{k}            = 'frame';
parentFolder{k}    = outputFolder_UpperBodies;
newFolder{k}       = 'david9';
dataFolder{k}      = [datasetFolder_UpperBodies 'david9\'];
workspaceFolder{k} = [outputFolder_UpperBodies 'david9\]';
frameStart{k}      = 0;
frameEnd{k}        = 215;

k = k + 1;
%Phil
sequence{k}        = 'phil';
name{k}            = 'frame';
parentFolder{k}    = outputFolder_UpperBodies;
newFolder{k}       = 'phil9';
dataFolder{k}      = [datasetFolder_UpperBodies 'phil9\'];
workspaceFolder{k} = [outputFolder_UpperBodies 'phil9\'];
frameStart{k}      = 0;
frameEnd{k}        = 244;

k = k + 1;
%Ricardo
sequence{k}        = 'ricardo';
name{k}            = 'frame';
parentFolder{k}    = outputFolder_UpperBodies;
newFolder{k}       = 'ricardo9';
dataFolder{k}      = [datasetFolder_UpperBodies 'ricardo9\'];
workspaceFolder{k} = [outputFolder_UpperBodies 'ricardo9\'];
frameStart{k}      = 0;
frameEnd{k}        = 215;

k = k + 1;
%Sarah
sequence{k}        = 'sarah';
name{k}            = 'frame';
parentFolder{k}    = outputFolder_UpperBodies;
newFolder{k}       = 'sarah9';
dataFolder{k}      = [datasetFolder_UpperBodies 'sarah9\'];
workspaceFolder{k} = [outputFolder_UpperBodies 'sarah9\'];
frameStart{k}      = 0;
frameEnd{k}        = 206;

k = k + 1;
%Longdress
sequence{k}        = 'longdress';
name{k}            = 'longdress_vox10_';
parentFolder{k}    = outputFolder_FullBodies;
newFolder{k}       = 'longdress';
dataFolder{k}      = [datasetFolder_FullBodies 'longdress\'];
workspaceFolder{k} = [outputFolder_FullBodies 'longdress\'];
frameStart{k}      = 1051;
frameEnd{k}        = 1350;

k = k + 1;
%Loot
sequence{k}        = 'loot';
name{k}            = 'loot_vox10_';
parentFolder{k}    = outputFolder_FullBodies;
newFolder{k}       = 'loot';
dataFolder{k}      = [datasetFolder_FullBodies 'loot\'];
workspaceFolder{k} = [outputFolder_FullBodies 'loot\'];
frameStart{k}      = 1000;
frameEnd{k}        = 1299;

k = k + 1;
%RedAndBlack
sequence{k}        = 'redandblack';
name{k}            = 'redandblack_vox10_';
parentFolder{k}    = outputFolder_FullBodies;
newFolder{k}       = 'redandlack';
dataFolder{k}      = [datasetFolder_FullBodies 'redandblack\'];
workspaceFolder{k} = [outputFolder_FullBodies 'redandblack\'];
frameStart{k}      = 1450;
frameEnd{k}        = 1749;

k = k + 1;
%Soldier
sequence{k}        = 'soldier';
name{k}            = 'soldier_vox10_';
parentFolder{k}    = outputFolder_FullBodies;
newFolder{k}       = 'soldier';
dataFolder{k}      = [datasetFolder_FullBodies 'soldier\'];
workspaceFolder{k} = [outputFolder_FullBodies 'soldier\'];
frameStart{k}      = 0536;
frameEnd{k}        = 0835;

N = k;
for (k = 1:1:N)
    for (i = frameStart{k}:1:frameEnd{k})
        strNum = num2str(i);
        leadingZeros = char(zeros(1,4 - length(strNum)) + 48);
        filename = [name{k} '' leadingZeros '' strNum ''];
        
        inputFile   = [dataFolder{k} filename '.ply'];
        binaryFile  = [workspaceFolder{k} filename '.bin'];
        
        %Checks if the output folder exists.
        [success, message, messageid] = mkdir(parentFolder{k},newFolder{k});
        if (success == 0)
            error(['Could not create output folder - Message: ' message ' .'])
        end
        
        %Encodes the file
        enc = encodePointCloudGeometry(inputFile, binaryFile);      
        
        %Writes the results
        filename = [workspaceFolder{k} sequence{k} '_results_dyadicDecomposition.txt'];
        fid = fopen(filename,'a');
        fprintf(fid,'%2.4f\n',enc.rate_bpov);
        fclose(fid);
    end
end