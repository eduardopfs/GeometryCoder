% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = encodeParam(A,cabac)

cabac.ParamBitstream = cabac.ParamBitstream.putBit(A);