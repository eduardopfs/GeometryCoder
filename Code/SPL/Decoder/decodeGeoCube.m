% [geoCube,cabac] = decodeGeoCube(geoCube,cabac, iStart,iEnd, Y)
%  
% This decodes the dyadic decomposition or the single mode encoding,
% depending on what is found on the bitstream.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [geoCube,cabac] = decodeGeoCube(geoCube,cabac, iStart,iEnd, Y)

[sy,sx,sz] = size(geoCube);

if (nargin == 4)
    %Initializes the tag.
    cabac.BACEngineDecoder = initBACDecoder(cabac.BACEngineDecoder);
    
    Y = zeros(sy,sx,'logical');
    [Y,cabac] = decodeImageBAC(Y,cabac);
end

%Reads 1 bit from the param bitstream.
[cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();

%Decodes the correct image.
if (bit == 0)
    %Variables for dividing the partition
    mid = ((iEnd - iStart + 1) / 2) + iStart - 1;
    
    lStart = iStart;
    lEnd   = mid;
    N      = lEnd - lStart + 1;
    
    rStart = mid + 1;
    rEnd   = iEnd;
    %NRight = rEnd - rStart + 1;
    
    %If this variable are to be used, they will be updated below.
    nSymbolsLeft  = 0;
    nSymbolsRight = 0;
    
    %Reads 2 more bits, indicating whether or not each image was encoded.
    [cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();
    encodeYleft  = bit;
    [cabac.ParamBitstream, bit] = cabac.ParamBitstream.read1Bit();
    encodeYright = bit;
    
    %This level was encoded only if it had pixels in both images.
    encodeThisLevel = encodeYleft && encodeYright;
    if (encodeThisLevel)
        %Attempts to decode the left image.
        Yleft        = zeros(sy,sx,'logical');
        mask_Yleft   = Y;
        nSymbolsLeft = sum(mask_Yleft(:));
        
        if (nSymbolsLeft > 0)
            if (lStart == 1)
                [Yleft, cabac] = decodeImageBAC_withMask2(Yleft, mask_Yleft, cabac);
            else
                %This means I already have enough images for a 3D context.
                Yleft_left = silhouette(geoCube,lStart - N, lEnd - N);
                [Yleft, cabac] = decodeImageBAC_withMask_3DContexts_ORImages2(Yleft, mask_Yleft, Yleft_left, cabac);
            end
        end
        
        
        %Attempts to decode the right image.
        %I already know something about the right image.
        Yright           = and(Y,not(Yleft));
        mask_Yright      = and(Y,Yleft);
        nSymbolsRight    = sum(mask_Yright(:));
        
        if (nSymbolsRight > 0)
            %For the right image, I always have enough images for the 3D
            %context.
            Yright_left = Yleft;
            [Yright, cabac] = decodeImageBAC_withMask_3DContexts_ORImages2(Yright, mask_Yright, Yright_left, cabac);            
        end               
    else
        %If only one side had pixels, I have to do something else. 
        if ((encodeYleft == 1) && (encodeYright == 0))
            %This means only the left image had pixels.
            %Thus:
            Yleft  = Y;
            Yright = zeros(sy,sx,'logical');
        elseif ((encodeYleft == 0) && (encodeYright == 1))
            %This means only the right image had pixels.
            %Thus:
            Yright = Y;
            Yleft  = zeros(sy,sx,'logical');
        else
            %This means that neither image had pixels, and thus this
            %function should NOT have been called.
            error('Bitstream parsing error.');
        end
    end
    
    %Check if Yleft and Yright are already the slices, so they are inserted
    %into the geocube.    
    if (N == 1)
        %This means I have reached a leaf.
        %Write the decoded images in the geoCube.
        geoCube(:,:,lStart) = Yleft;
        geoCube(:,:,rStart) = Yright;
    else
        %Then I have to call this function recursively
        if (encodeYleft && (lEnd > lStart))            
            [geoCube,cabac] = decodeGeoCube(geoCube,cabac, lStart,lEnd, Yleft);
        end
        
        if (encodeYright && (rEnd > rStart))
            [geoCube,cabac] = decodeGeoCube(geoCube,cabac, rStart,rEnd, Yright);
        end        
    end
        
else
    %Decode this range using the single mode encoding.
    [geoCube,cabac] = decodeSliceAsSingles(geoCube,cabac, iStart,iEnd, Y);
end