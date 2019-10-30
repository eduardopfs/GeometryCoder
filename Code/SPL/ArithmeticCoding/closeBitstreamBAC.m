% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cod_in = closeBitstreamBAC(cod_in)

m = cod_in.m;

ln = uint32(cod_in.ln);

while(m > 0)
    m = m - 1;
    p2 = uint32(2^m);
    bit = bitand(ln,p2) ~= 0;
    cod_in.bitstream = cod_in.bitstream.putBit(bit);
end
