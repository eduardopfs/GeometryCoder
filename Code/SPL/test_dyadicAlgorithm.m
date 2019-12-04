%This test only works for 9 bits sequences!
function [cabac, nBits, nSymbolsEncoded] = test_dyadicAlgorithm(maxdepth, Y, cabac, d, nBits, nSymbolsEncoded, iStart)

if (nargin == 3)
    d      = 0;
    
    %Initializes the nBits and nSymbolsEncoded variables.
    nBits           = cell(1,maxdepth+1);
    nSymbolsEncoded = cell(1,maxdepth+1);
    
    for (k = 0:1:maxdepth)
        nBits{k+1}           = zeros(1,2^k);
        nSymbolsEncoded{k+1} = zeros(1,2^k);
    end
    
    iStart = 1;
end

%Encodes the first image.
if (d == 0)
    
    
    %Depth 0
    cabac              = encodeImageBAC(Y{1}{1},cabac);
    nBits{1}           = cabac.BACEngine.bitstream.size();
    nSymbolsEncoded{1} = 512 * 512;
    %disp(['Depth ' num2str(d) ' | Image ' num2str(1) ' - nSymbols: ' num2str(nSymbolsEncoded{1}) ' - NBits = ' num2str(nBits{1}) '  bits'])
    
    if (maxdepth == 0)
        return;
    end
    %Automatically goes to the next depth.
    d = 1;
end

%If I have reached the maxdepth, return!
if (maxdepth > 0)
    %Start encoding the left and right images for each part.
    iParent = ceil(iStart/2);
    mask    = Y{d}{iParent};
    
    Yleft  = Y{d+1}{iStart};
    Yright = Y{d+1}{iStart+1};
    
    %if (d == 2) keyboard; end
    
    %Encode the left image.
    %Is there any UNKNOWN pixel that I need to transmit?
    nSymbolsLeftMask = (sum(mask(:)) > 0);
    YleftNotEmpty    = (sum(Yleft(:))  ~= 0);
    
    encodeLeftImage = nSymbolsLeftMask && YleftNotEmpty;
    if (encodeLeftImage)
        if (iStart == 1)
            nbitsStart                    = cabac.BACEngine.bitstream.size();
            cabac                         = encodeImageBAC_withMask2(Yleft,mask,cabac);
            nBits{d+1}(iStart)            = cabac.BACEngine.bitstream.size() - nbitsStart;
            nSymbolsEncoded{d+1}(iStart)  = sum(mask(:));
        else
            Yleftleft                     = Y{d+1}{iStart - 1};
            nbitsStart                    = cabac.BACEngine.bitstream.size();
            cabac                         = encodeImageBAC_withMask_3DContexts_ORImages2(Yleft,mask, Yleftleft,cabac);
            nBits{d+1}(iStart)            = cabac.BACEngine.bitstream.size() - nbitsStart;
            nSymbolsEncoded{d+1}(iStart)  = sum(mask(:));
        end
    end
    %disp(['Depth ' num2str(d) ' | Image ' num2str(iStart) ' - nSymbols: ' num2str(nSymbolsEncoded{d+1}(iStart)) ' - NBits = ' num2str(nBits{d+1}(iStart)) '  bits'])
    %if (d == 2) keyboard; end
    
    %Encode the right image
    mask              = and(mask,Yleft);
    nSymbolsRightMask = (sum(mask(:)) > 0);
    YrightNotEmpty    = (sum(Yright(:))  ~= 0);
    
    encodeRightImage = nSymbolsRightMask && YrightNotEmpty;    
    if (encodeRightImage)
        Yrightleft                     = Yleft;
        nbitsStart                     = cabac.BACEngine.bitstream.size();
        cabac                          = encodeImageBAC_withMask_3DContexts_ORImages2(Yright,mask, Yrightleft,cabac);
        nBits{d+1}(iStart+1)           = cabac.BACEngine.bitstream.size() - nbitsStart;
        nSymbolsEncoded{d+1}(iStart+1) = sum(mask(:));
    end
    %disp(['Depth ' num2str(d) ' | Image ' num2str(iStart+1) ' - nSymbols: ' num2str(nSymbolsEncoded{d+1}(iStart+1)) ' - NBits = ' num2str(nBits{d+1}(iStart+1)) '  bits'])
    %if (d == 2) keyboard; end

    if (d < maxdepth)
        %Calls the algorithm recursively.
        iStartNextDepth_Left  = (iStart - 1)*2 + 1;
        iStartNextDepth_Right = (iStart)*2 + 1;
        if (encodeLeftImage)
            [cabac, nBits, nSymbolsEncoded] = test_dyadicAlgorithm(maxdepth, Y, cabac, d+1, nBits, nSymbolsEncoded, iStartNextDepth_Left);
        end
        if (encodeRightImage)
            [cabac, nBits, nSymbolsEncoded] = test_dyadicAlgorithm(maxdepth, Y, cabac, d+1, nBits, nSymbolsEncoded, iStartNextDepth_Right);
        end
    end

end



end %end function