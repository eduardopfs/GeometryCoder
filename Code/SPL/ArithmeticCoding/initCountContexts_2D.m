% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function countContexts = initCountContexts_2D(numberOfContexts)

nContexts = 2^numberOfContexts;

%Start each context with an initial count.
if (nContexts == 1)
    countContexts = [1 1];
else
    countContexts = zeros(nContexts,2);
    for k = 1:1:nContexts
        binWord = dec2bin(k-1,numberOfContexts);
        nZeros = sum(binWord == '0') + 1;
        nOnes  = sum(binWord == '1') + 1;
        countContexts(k,:) = [nZeros nOnes];        
    end
end

