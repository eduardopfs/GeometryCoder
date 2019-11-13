% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function dec = initBACDecoder(dec)

%Initializes the tag.
tagVector = zeros(1,dec.m,'logical');
w         = zeros(1,dec.m);

for k = 1:1:dec.m
    [dec.bitstream, currBit] = dec.bitstream.read1Bit();
    tagVector(k)             = currBit;
    w(k)                     = 2^(dec.m - k);
end

currTag = sum(w .* double(tagVector));

dec.currTAG = uint32(currTag);
