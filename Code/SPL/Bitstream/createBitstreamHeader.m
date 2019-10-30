% function bitstream_header = createBitstreamHeader(limit, axis, length_BitstreamParam)
%
% The header uses:
%   6 bits for the cube size
%   2 bits for the axis
%  16 bits for the number of symbols in the bitstream parameters.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function bitstream_header = createBitstreamHeader(limit, axis, length_BitstreamParam)

nBits = uint8(log2(limit+1));

%Performs the dec2bin conversion (using 6 bits)
vSize = (bitand(nBits,uint8([32 16 8 4 2 1])) ~= 0);

%Get the axis (using 2 bits)
if (axis == 'x')
    vAxis = logical([0 0]);
elseif (axis == 'y')
    vAxis = logical([0 1]);
else
    vAxis = logical([1 0]);
end

%Gets the param length (using 16 bits)
vBitstreamParam = (bitand(uint16(length_BitstreamParam),uint16([32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1])) ~= 0);

bitstream_header = Bitstream(20 + length_BitstreamParam + 1);
bitstream_header = bitstream_header.putBit(vSize(1));
bitstream_header = bitstream_header.putBit(vSize(2));
bitstream_header = bitstream_header.putBit(vSize(3));
bitstream_header = bitstream_header.putBit(vSize(4));
bitstream_header = bitstream_header.putBit(vSize(5));
bitstream_header = bitstream_header.putBit(vSize(6));

bitstream_header = bitstream_header.putBit(vAxis(1));
bitstream_header = bitstream_header.putBit(vAxis(2));

bitstream_header = bitstream_header.putBit(vBitstreamParam(1));
bitstream_header = bitstream_header.putBit(vBitstreamParam(2));
bitstream_header = bitstream_header.putBit(vBitstreamParam(3));
bitstream_header = bitstream_header.putBit(vBitstreamParam(4));
bitstream_header = bitstream_header.putBit(vBitstreamParam(5));
bitstream_header = bitstream_header.putBit(vBitstreamParam(6));
bitstream_header = bitstream_header.putBit(vBitstreamParam(7));
bitstream_header = bitstream_header.putBit(vBitstreamParam(8));
bitstream_header = bitstream_header.putBit(vBitstreamParam(9));
bitstream_header = bitstream_header.putBit(vBitstreamParam(10));
bitstream_header = bitstream_header.putBit(vBitstreamParam(11));
bitstream_header = bitstream_header.putBit(vBitstreamParam(12));
bitstream_header = bitstream_header.putBit(vBitstreamParam(13));
bitstream_header = bitstream_header.putBit(vBitstreamParam(14));
bitstream_header = bitstream_header.putBit(vBitstreamParam(15));
bitstream_header = bitstream_header.putBit(vBitstreamParam(16));
