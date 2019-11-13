% [geoCube,cabac] = decodeSliceAsSingles(geoCube,cabac, iStart,iEnd, Y)
%  
% This decodes a range encoded with the single mode encoding.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [geoCube,cabac] = decodeSliceAsSingles(geoCube,cabac, iStart,iEnd, Y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Uses the parent as mask.
%mask = Y;
[sy, sx]  = size(Y);
maskLast = zeros(sy,sx,'logical');

[idx_i, idx_j] = find(Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Iterates through all the slices
for i = iStart:1:(iEnd-1)
    %Reads if this slice was encoded.
    [cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();
   
    %If it was not encoded, then I do not have to do anything.
    if (bit == 1)
        %Gets the slice for the 3D context.
        if (i == 1)
            Yleft = zeros(sy,sx,'logical');
        else
            Yleft = geoCube(:,:,i-1);
        end   
        
        %Allocates the image
        A = zeros(sy,sx,'logical');
        
        %Decodes the current image.
        [A, cabac] = decodeImageBAC_withMask_3DContexts2(A, idx_i, idx_j, Yleft, cabac);
        
        %Puts it in the geoCube.
        geoCube(:,:,i) = A;
        
        %Prepares for the last mask!        
        maskLast = or(A,maskLast);    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Decodes the last image.
%Reads if this slice was encoded.
[cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();

%If it is zero, it is done.
if (bit == 1)    
    %For the last slice, the mask is a bit different.
    mask = and(Y,maskLast);
    
    [idx_i, idx_j] = find(mask');
    
    %Gets the slice for the 3D context.
    if (iEnd == 1)
        Yleft = zeros(sy,sx,'logical');
    else
        Yleft = geoCube(:,:,iEnd-1);
    end
    
    %Allocates the image with the current information
    A = and(Y,not(maskLast));
    
    %Decodes the current image.
    [A, cabac] = decodeImageBAC_withMask_3DContexts2(A, idx_i, idx_j, Yleft, cabac);
   
    %Puts it in the geoCube.
    geoCube(:,:,iEnd) = A;    
end
