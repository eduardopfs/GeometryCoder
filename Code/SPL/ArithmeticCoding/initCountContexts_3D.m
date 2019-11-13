% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function countContexts = initCountContexts_3D(numberOfContexts3D, numberOfContexts2D)

nContexts2D = 2^numberOfContexts2D;

nContexts3D = 2^numberOfContexts3D;
%Start each context with an initial count.
countContexts = zeros(nContexts3D, nContexts2D, 2);

for j = 1:1:nContexts3D
    binWord  = dec2bin(j-1,numberOfContexts3D);
    nZeros3D = sum(binWord == '0') + 1;
    nOnes3D  = sum(binWord == '1') + 1;
    for k = 1:1:nContexts2D
        binWord  = dec2bin(k-1,numberOfContexts2D);
        nZeros2D = sum(binWord == '0') + 1;
        nOnes2D  = sum(binWord == '1') + 1;
        countContexts(j,k,1) = nZeros3D + nZeros2D + 1;
        countContexts(j,k,2) = nOnes3D + nOnes2D + 1;
    end
end
