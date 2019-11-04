% function comparePlys
%  Compares two point clouds.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function eq = comparePlys(file1, file2)

eq = 1;

%pc1 = pcread(file1);
%pc2 = pcread(file2);

pp1 = pointCloud(file1);
pp2 = pointCloud(file2);

pc1.Location = pp1.X;
pc1.Count = pp1.noPoints;
mm = min(pp1.X);
mx = max(pp1.X);
pc1.XLimits = [mm(1) mx(1)];
pc1.YLimits = [mm(2) mx(2)];
pc1.ZLimits = [mm(3) mx(3)];

pc2.Location = pp2.X;
pc2.Count = pp2.noPoints;
mm = min(pp2.X);
mx = max(pp2.X);
pc2.XLimits = [mm(1) mx(1)];
pc2.YLimits = [mm(2) mx(2)];
pc2.ZLimits = [mm(3) mx(3)];


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
