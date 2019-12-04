
%A point cloud filename
%filename = 'C:\eduardo\Dropbox\PointCloud_Geometry\workspace\frame0000.ply';
%matFile  = 'ricardo_frame0000.mat';

%Opens the point cloud.
[vertex, ~] = plyRead(filename, 0);

ptCloud.Location = vertex;
ptCloud.Count = length(vertex);
mm = min(vertex);
mx = max(vertex);
ptCloud.XLimits = [mm(1) mx(1)];
ptCloud.YLimits = [mm(2) mx(2)];
ptCloud.ZLimits = [mm(3) mx(3)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Gets a few silhouette images.
dMax = 9;
Y = cell(1,dMax + 1);
for (d = 0:1:dMax)
    
    iMax = 2^(d);
    N    = 512 / iMax;
    
    Y{d+1} = cell(1,iMax);
    for (i = 0:1:(iMax - 1))
        iStart = i * N + 1;
        iEnd   = i * N + N;
        Y{d+1}{i+1} = silhouetteFromCloud(ptCloud.Location, 512, 'y', iStart, iEnd, false);
    end
end

resultsA = zeros(dMax,3);
resultsB = zeros(dMax,3);
resultsC = zeros(dMax,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initializes a cabac.
BACParams = getBACParams();
BACParams.numberOfContextsIndependent = 10;
BACParams.numberOfContextsMasked      = 5;
BACParams.windowSizeFor3DContexts     = 1;
BACParams.numberOf3DContexts          = 9;
BACParams.numberOfContextsParams      = 4;

%BACParams.m               = 32;
%BACParams.maxValueContext = 1048576;

cabac = getCABAC();
cabac = initCABAC(cabac, BACParams);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test depths.
for (depth = 1:1:dMax)
    tStartA = tic;
    [cabacA, nBitsA, nSymbolsEncodedA] = test_dyadicAlgorithm(depth, Y, cabac);
    timeA = toc(tStartA);
    
    tStartB = tic;
    [cabacB, nBitsB, nSymbolsEncodedB] = test_SingleModeEncodingAlgorithm(depth, Y, cabac);
    timeB = toc(tStartB);
    
    tStartC = tic;
    [cabacC, nBitsC, nSymbolsEncodedC] = test_SingleModeEncodingAlgorithm_withParentMask(depth, Y, cabac);
    timeC = toc(tStartC);
    
    totalBitsA   = 0;
    totalSymbolsA = 0;
    for (i = 1:1:length(nBitsA))
        totalBitsA   = totalBitsA + sum(nBitsA{i});
        totalSymbolsA = totalSymbolsA + sum(nSymbolsEncodedA{i});
    end
    
    totalBitsB = sum(nBitsB);
    totalSymbolsB = sum(nSymbolsEncodedB);
    
    totalBitsC = sum(nBitsC);
    totalSymbolsC = sum(nSymbolsEncodedC);
    
    resultsA(depth,:) = [totalSymbolsA totalBitsA timeA];
    resultsB(depth,:) = [totalSymbolsB totalBitsB timeB];
    resultsC(depth,:) = [totalSymbolsC totalBitsC timeC];
    
    temp = num2str(totalSymbolsA);
    strSymbolsA = [char(zeros(1,12-length(temp))+32) temp];
    temp = num2str(totalBitsA);
    strBitsA = [char(zeros(1,9-length(temp))+32) temp];
    temp = num2str(timeA,'%.1f');
    strTimeA = [char(zeros(1,8-length(temp))+32) temp];
    
    temp = num2str(totalSymbolsB);
    strSymbolsB = [char(zeros(1,12-length(temp))+32) temp];
    temp = num2str(totalBitsB);
    strBitsB = [char(zeros(1,9-length(temp))+32) temp];
    temp = num2str(timeB,'%.1f');
    strTimeB = [char(zeros(1,8-length(temp))+32) temp];
    
    temp = num2str(totalSymbolsC);
    strSymbolsC = [char(zeros(1,12-length(temp))+32) temp];
    temp = num2str(totalBitsC);
    strBitsC = [char(zeros(1,9-length(temp))+32) temp];
    temp = num2str(timeC,'%.1f');
    strTimeC = [char(zeros(1,8-length(temp))+32) temp];
    
    disp('')
    disp('=====================================================================')
    disp(['Depth ' num2str(depth) '         Symbols |      Bits |  Seconds' ])
    disp(['Method A = ' strSymbolsA ' | ' strBitsA ' | ' strTimeA])
    disp(['Method B = ' strSymbolsB ' | ' strBitsB ' | ' strTimeB])
    disp(['Method C = ' strSymbolsC ' | ' strBitsC ' | ' strTimeC])
end

save(matFile,'resultsA','resultsB','resultsC');
