% function comparePlys
%  Compares two point clouds.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function eq = comparePlys(file1, file2)

eq = 1;

pc1 = pcread(file1);
pc2 = pcread(file2);

[N1 d1] = size(pc1.Location);
[N2 d2] = size(pc2.Location);

if (N1 ~= N2)
    eq = 0;
else
    for (i = 1:1:N1)
        currXYZ = pc1.Location(i,:);
        
        temp3 = (pc2.Location == currXYZ);
        temp1 = and(and(temp3(:,1),temp3(:,2)),temp3(:,3));
        
        idx = find(temp1 == 1,1,'first');
        
        if (isempty(idx))
            eq = 0;
            break;
        end
    end
end
