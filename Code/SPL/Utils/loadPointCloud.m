function enc = loadPointCloud(enc)

disp(['Loading file ' enc.params.pointCloudFile])
filename = [enc.params.dataFolder enc.params.pointCloudFile];

%Load the Point Cloud file.
pointCloud = pcread(filename);

%Gets the limit (i.e., the bitdepth).
%ptLocation = pointcloud.Location;
boundlimits = [0 1 3 7 15 31 63 127 255 511 1023 2047 4095]; %define os limites possiveis
bound = max([max(pointCloud.XLimits) max(pointCloud.YLimits) max(pointCloud.ZLimits)]); 
limit = boundlimits(bound<=boundlimits);
limit = limit(1);

enc.pointCloud             = pointCloud;
enc.pcLimit                = limit;
enc.numberOfOccupiedVoxels = length(pointCloud.Location);
enc.params.nBits           = log2(limit + 1);