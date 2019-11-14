function enc = loadPointCloud(enc)

disp(['Loading file ' enc.params.pointCloudFile])
filename = [enc.params.dataFolder enc.params.pointCloudFile];

%Load the Point Cloud file.
%pointCloud = pcread(filename);
%pc = pointCloud(filename);
[vertex, ~] = plyRead(filename, 0);

ptCloud.Location = vertex;
ptCloud.Count = length(vertex);
mm = min(vertex);
mx = max(vertex);
ptCloud.XLimits = [mm(1) mx(1)];
ptCloud.YLimits = [mm(2) mx(2)];
ptCloud.ZLimits = [mm(3) mx(3)];

%Gets the limit (i.e., the bitdepth).
%ptLocation = pointcloud.Location;
boundlimits = [0 1 3 7 15 31 63 127 255 511 1023 2047 4095]; %define os limites possiveis
bound = max([max(ptCloud.XLimits) max(ptCloud.YLimits) max(ptCloud.ZLimits)]);
limit = boundlimits(bound<=boundlimits);
limit = limit(1);

%enc.pointCloud            = pointCloud;
enc.pointCloud             = ptCloud;
enc.pcLimit                = limit;
enc.numberOfOccupiedVoxels = length(ptCloud.Location);
enc.params.nBits           = log2(limit + 1);
