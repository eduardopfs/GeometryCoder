%This test only works for 9 bit sequences.
function [cabac, nBits, nSymbolsEncoded] = test_SingleModeEncodingAlgorithm_withParentMask(maxdepth, Y, cabac)


nImages = 2^maxdepth;

if (maxdepth == 0)
    nBits           = zeros(1,1);
    nSymbolsEncoded = zeros(1,1);
else
    nBits           = zeros(1,nImages + 1);
    nSymbolsEncoded = zeros(1,nImages + 1);

end


%First, it encodes the image at depth 0.
nbitsStart         = cabac.BACEngine.bitstream.size();
cabac              = encodeImageBAC(Y{1}{1},cabac);
nBits(1)           = cabac.BACEngine.bitstream.size() - nbitsStart;
nSymbolsEncoded(1) = 512 * 512;
%disp(['Depth 0 | Image ' num2str(1) ' - nSymbols: ' num2str(nSymbolsEncoded(1)) ' - NBits = ' num2str(nBits(1)) '  bits'])

mask = Y{1}{1};
maskLast = zeros(512,512,'logical');

d = maxdepth + 1;
if (maxdepth > 0)
    %Encodes the first image.
    if (sum(Y{d}{1}(:)) ~= 0)
        nbitsStart         = cabac.BACEngine.bitstream.size();
        cabac              = encodeImageBAC_withMask2(Y{d}{1},mask,cabac);
        nBits(2)           = cabac.BACEngine.bitstream.size() - nbitsStart;
        nSymbolsEncoded(2) = sum(mask(:));
        maskLast           = or(Y{d}{1},maskLast);
    end
    %disp(['Depth ' num2str(d-1) ' | Image ' num2str(2) ' - nSymbols: ' num2str(nSymbolsEncoded(2)) ' - NBits = ' num2str(nBits(2)) '  bits'])
    
    for (i = 2:1:(nImages - 1))
        if (sum(Y{d}{i}(:)) ~= 0)
            nbitsStart           = cabac.BACEngine.bitstream.size();
            cabac                = encodeImageBAC_withMask_3DContexts_ORImages2(Y{d}{i},mask, Y{d}{i-1},cabac);
            nBits(i+1)           = cabac.BACEngine.bitstream.size() - nbitsStart;
            nSymbolsEncoded(i+1) = sum(mask(:));
            maskLast             = or(Y{d}{i},maskLast);
        end
        %disp(['Depth ' num2str(d-1) ' | Image ' num2str(i+1) ' - nSymbols: ' num2str(nSymbolsEncoded(i+1)) ' - NBits = ' num2str(nBits(i+1)) '  bits'])
    end
    
    mask = and(mask,maskLast);
    i = nImages;
    if (sum(Y{d}{i}(:)) ~= 0)
        nbitsStart           = cabac.BACEngine.bitstream.size();
        cabac                = encodeImageBAC_withMask_3DContexts_ORImages2(Y{d}{i},mask, Y{d}{i-1},cabac);
        nBits(i+1)           = cabac.BACEngine.bitstream.size() - nbitsStart;
        nSymbolsEncoded(i+1) = sum(mask(:));
        maskLast             = or(Y{d}{i},maskLast);
    end
    %disp(['Depth ' num2str(d-1) ' | Image ' num2str(i+1) ' - nSymbols: ' num2str(nSymbolsEncoded(i+1)) ' - NBits = ' num2str(nBits(i+1)) '  bits'])
end