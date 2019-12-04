%This test only works for 9 bit sequences.
function [cabac, nBits, nSymbolsEncoded] = test_SingleModeEncodingAlgorithm(maxdepth, Y, cabac)

mask = ones(512,512,'logical');

nImages = 2^maxdepth;

nBits = zeros(1,nImages);
nSymbolsEncoded = zeros(1,nImages);

d = maxdepth + 1;
%Encodes the first image.
if (sum(Y{d}{1}(:)) ~= 0)
    nbitsStart         = cabac.BACEngine.bitstream.size();
    cabac              = encodeImageBAC(Y{d}{1},cabac);
    nBits(1)           = cabac.BACEngine.bitstream.size() - nbitsStart;
    nSymbolsEncoded(1) = 512 * 512;
end
%disp(['Image ' num2str(1) ' - nSymbols: ' num2str(nSymbolsEncoded(1)) ' - NBits = ' num2str(nBits(1)) '  bits'])

for (i = 2:1:nImages)
    if (sum(Y{d}{i}(:)) ~= 0)
        nbitsStart         = cabac.BACEngine.bitstream.size();
        cabac              = encodeImageBAC_withMask_3DContexts_ORImages2(Y{d}{i},mask, Y{d}{i-1},cabac);
        nBits(i)           = cabac.BACEngine.bitstream.size() - nbitsStart;
        nSymbolsEncoded(i) = 512 * 512;        
    end
    %disp(['Image ' num2str(i) ' - nSymbols: ' num2str(nSymbolsEncoded(i)) ' - NBits = ' num2str(nBits(i)) '  bits'])
end
