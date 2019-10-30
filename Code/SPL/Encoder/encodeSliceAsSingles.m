% Function cabac = encodeSliceAsSingles(geoCube,cabac,iStart,iEnd,Y)
%  This tests the single mode encoding. 
%  Encodes all images in the range iStart to iEnd, using the received Y as
%  mask (except for the last image, which uses a different mask).
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = encodeSliceAsSingles(geoCube,cabac,iStart,iEnd,Y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Uses the parent as mask.
[sy sx]  = size(Y);
maskLast = zeros(sy,sx,'logical');

[idx_i, idx_j] = find(Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Iterates through all the slices
for (i = iStart:1:(iEnd-1))
    %Gets the current slice to be encoded.
    A = geoCube(:,:,i);
    nSymbolsA = sum(A(:));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %First, I have to signal if this slice will be encoded.
    if (nSymbolsA == 0)
        cabac = encodeParam(logical(0),cabac);
    else
        cabac = encodeParam(logical(1),cabac);
    end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Encodes the slice
    %nBits = cabac.BACEngine.bitstream.size();   
    if (nSymbolsA ~= 0)
        %Prepares for the last mask!        
        maskLast = or(A,maskLast);
        
        %Gets the left slice for the 3D context.
        if (i == 1)
            Yleft = zeros(sy,sx,'logical');
        else
            Yleft = geoCube(:,:,i-1);
        end
        
        %Actually encodes the image.
        cabac = encodeImageBAC_withMask_3DContexts2(A,idx_i, idx_j,Yleft,cabac);
    end
    
    %nBitsImage = cabac.BACEngine.bitstream.size() - nBits + 1;
    %disp(['  Single (' num2str(i) ') - Rate = ' num2str(nBitsImage) ''])    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Encodes the last image.
A = geoCube(:,:,iEnd);
nSymbolsA = sum(A(:));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%First, I have to signal if this slice will be encoded.
if (nSymbolsA == 0)
    cabac = encodeParam(logical(0),cabac);
else
    cabac = encodeParam(logical(1),cabac);
end

%nBits = cabac.BACEngine.bitstream.size();
%For the last slice, the mask is a bit different. 
if (nSymbolsA ~= 0)
    mask = and(Y,maskLast);
    
    [idx_i, idx_j] = find(mask');
    
    %%%%%%%%%%%%%%%%%%%
    %Encodes the slice
    if (iEnd == 1)
        Yleft = zeros(sy,sx,'logical');
    else
        Yleft = geoCube(:,:,iEnd-1);
    end
    
    %Actually encodes the image.
    cabac = encodeImageBAC_withMask_3DContexts2(A,idx_i, idx_j,Yleft,cabac);
end
%nBitsImage = cabac.BACEngine.bitstream.size() - nBits + 1;
%disp(['  Single (' num2str(i) ') - Rate = ' num2str(nBitsImage) ''])    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
