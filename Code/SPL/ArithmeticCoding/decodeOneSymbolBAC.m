% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [dec, symbol] = decodeOneSymbolBAC(dec, c)

%Gets the MPS and LPS
if (c.MPS == false)
    mps = false;
    lps = true;
else
    mps = true;
    lps = false;
end

%Gets the interval
currTag = double(dec.currTAG);
l0 = double(dec.ln);
u0 = double(dec.un);


%Computes the tagStar.
t = floor(((currTag - l0 + 1) * c.totalCount - 1)/(u0 - l0 + 1));
tagStar = uint32(t);

%Decodes the symbol.
if (tagStar < c.countMPS)
    %Decodifica um MPS.
    symbol = mps;
    
    %Updates the interval
    l1 = uint32(l0);
    
    temp = floor(((u0 - l0 + 1) * c.countMPS)/c.totalCount);
    u1 = uint32(l0 + temp - 1);
else
    %Decodifica um LPS.
    symbol = lps;
    
    %Updates the interval
    temp = floor(((u0 - l0 + 1) * c.countMPS)/c.totalCount);
    l1 = uint32(l0 + temp);
    
    u1 = uint32(u0); 
end

%Checks if I have to flush bits. 
ok = 1;
nBitsRemoved = 0;

%Initializes the tag1.
tag1 = dec.currTAG;



while (ok == 1)
    %Get the MSB for L and U.
    msb_l = (bitand(l1,dec.MSBMask) ~= 0);
    msb_u = (bitand(u1,dec.MSBMask) ~= 0);
    
    if (msb_l == msb_u)
        %If they are the same, I have to read a Bit from the bitstream.
        [dec.bitstream, currBit] = dec.bitstream.read1Bit();
                
        %Then I have to flush it out of l1 and u1.
        l1 = shiftLeft(l1,dec.m,0);
        u1 = shiftLeft(u1,dec.m,1);
        %Recomputes the tag.
        tag1 = shiftLeft(tag1, dec.m, currBit);
        
        nBitsRemoved = nBitsRemoved + 1;
    else
        ok = 0;
    end
end

%Updates the decoder. 
dec.ln = l1;
dec.un = u1;
dec.currTAG = tag1;
dec.nDecoded = dec.nDecoded + 1;

function v_out = shiftLeft(v,m,bit)

mask = uint32(2^m - 1);
t = bitshift(v,1);
t = bitand(t,mask);
v_out = uint32(t) + uint32(bit);
