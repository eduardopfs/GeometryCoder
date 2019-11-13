% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [limit, axis, length_header, length_BitstreamParam, bitstream] = parseBitstreamHeader(bitstream)

vSize           = zeros(1,6,'logical');
vAxis           = zeros(1,2,'logical');
vBitstreamParam = zeros(1,16,'logical');

for k = 1:1:6
    [bitstream, bit] = bitstream.read1Bit();
    vSize(k) = bit;
end

for k = 1:1:2
    [bitstream, bit] = bitstream.read1Bit();
    vAxis(k) = bit;
end

for k = 1:1:16
    [bitstream, bit] = bitstream.read1Bit();
    vBitstreamParam(k) = bit;
end

nBits    = sum([32 16 8 4 2 1] .* double(vSize));
limit    = 2^nBits - 1;

nAxis    = sum([2 1] .* double(vAxis));
if (nAxis == 0)
    axis = 'x';
elseif (nAxis == 1)
    axis = 'y';
elseif (nAxis == 2)
    axis = 'z';
else
    error('Bitstream parsing error. The axis is wrong.');
end

length_header         = 24;
length_BitstreamParam = sum([32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1] .* double(vBitstreamParam));

