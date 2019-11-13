%Contexts
%          14
%    11  9  6 10 12
% 15  7  4  2  3  8 16
% 13  5  1  ?
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function contextNumber = get2DContext(A, pixel, numberOfContexts)

% Initialize constants across repeated calls.
contX = [-1 0 +1 -1 -2 0 -2 +2 -1 +1 -2 +2 -3 0 -3 +3];
contY = [0 -1 -1 -1 0 -2 -1 -1 -2 -2 -2 -2 0 -3 -1 -1];

y = pixel(1) + 3;
x = pixel(2) + 3;

index = sub2ind(...
    size(A), ...
    y + contY(1:numberOfContexts), ...
    x + contX(1:numberOfContexts));

contextNumber = sum(2.^(0:numberOfContexts-1) .* A(index(1:numberOfContexts)));
    