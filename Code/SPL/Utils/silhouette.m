% function silhouette()
%  Generates a silhouette image.
%  Note that it always generates this image using the last dimension -
%  however, the geometry cube is generated alread rotated, depending on the
%  axis.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function A = silhouette(geoCube,iStart,iEnd)

A = geoCube(:,:,iStart);

for i = (iStart + 1):1:iEnd
    A = or(A,geoCube(:,:,i));
end