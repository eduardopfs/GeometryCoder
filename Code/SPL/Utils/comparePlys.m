% function comparePlys
%  Compares two point clouds.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function eq = comparePlys(file1, file2)

eq = 1;

%pc1 = pcread(file1);
%pc2 = pcread(file2);

%pp1 = pointCloud(file1);
%pp2 = pointCloud(file2);

[vertex1, ~] = plyRead(file1, 0);
[vertex2, ~] = plyRead(file2, 0);

pc1.Location = vertex1;
pc1.Count = length(vertex1);
mm = min(vertex1);
mx = max(vertex1);
pc1.XLimits = [mm(1) mx(1)];
pc1.YLimits = [mm(2) mx(2)];
pc1.ZLimits = [mm(3) mx(3)];

pc2.Location = vertex2;
pc2.Count = length(vertex2);
mm = min(vertex2);
mx = max(vertex2);
pc2.XLimits = [mm(1) mx(1)];
pc2.YLimits = [mm(2) mx(2)];
pc2.ZLimits = [mm(3) mx(3)];


[N1, ~] = size(pc1.Location);
[N2, ~] = size(pc2.Location);

if (N1 ~= N2)
    eq = 0;
else
    for i = 1:1:N1
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
