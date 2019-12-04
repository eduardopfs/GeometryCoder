% function silhouetteFromCloud(pointList, imSize, iStart, iEnd)
%  Generates a silhouette image.
%  
%  Assumes the pointList is in the conventional order ([x y z]).
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function image = silhouetteFromCloud(pointList, imSize, axis, iStart, iEnd, sparseM)
% Get axis to project points.
axisInd = find('xyz' == axis);

% Which rows in the points list have something interesting?
rows = ((pointList(:,axisInd)+1 >= iStart) & (pointList(:,axisInd)+1 <= iEnd));
inImage = pointList(rows,:)+1;
inImage(:,axisInd) = [];
inImage = unique(inImage, 'rows');

% Preallocate image
if sparseM
    image = spalloc(imSize, imSize, length(inImage));
else
    image = zeros(imSize,'logical');
end

% Flag image where there is a point projection.
image(sub2ind(size(image), ...
              inImage(:,1), ...
              inImage(:,2))) = 1;

%image = sparse(image == 1);          
end