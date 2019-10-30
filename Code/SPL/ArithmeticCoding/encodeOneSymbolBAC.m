% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cod = encodeOneSymbolBAC(cod, c, symbol)

%Find out if the symbol being encoded is the LPS or MPS. 
if (symbol == c.MPS)
    isMPS = 1;
else
    isMPS = 0;
end

%Updates the intervals
l0 = double(cod.ln);
u0 = double(cod.un);

if (isMPS)
    l1 = uint32(l0);
    
    temp = floor(((u0 - l0 + 1) * c.countMPS)/c.totalCount);
    u1 = uint32(l0 + temp - 1);
else
    temp = floor(((u0 - l0 + 1) * c.countMPS)/c.totalCount);
    l1 = uint32(l0 + temp);
    
    u1 = uint32(u0);    
end

%Checks if I have to flush bits. 
ok = 1;

while (ok == 1)
    %Get the MSB for L and U.
    msb_l = (bitand(l1,cod.MSBMask) ~= 0);
    msb_u = (bitand(u1,cod.MSBMask) ~= 0);
    
    if (msb_l == msb_u)
        %If they are the same, I have to flush this into the bitstream.
        cod.bitstream = cod.bitstream.putBit(msb_l);
        
        %Then I have to flush it out of l1 and u1.
        l1 = shiftLeft(l1,cod.m,0);
        u1 = shiftLeft(u1,cod.m,1);
    else
        ok = 0;
    end
end

%Updates the encoder. 
cod.ln = l1;
cod.un = u1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Auxiliary function
function v_out = shiftLeft(v,m,bit)

mask = uint32(2^m - 1);
t = bitshift(v,1);
t = bitand(t,mask);
v_out = uint32(t) + uint32(bit);
