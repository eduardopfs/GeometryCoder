%function [enc, rateBPOVPerAxis] = encodeGeometry2(enc)
%
% This is the main encoder function.
%  It performs the point cloud slicing, initializes the arithmetic coder,
%  tests all three axis, and writes the output file.
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [enc, rateBPOVPerAxis] = encodeGeometry2(enc)

axisArray      = 'xyz';
bestRate       = Inf;
bestAxis       = '0';
bestGeoCube    = [];
bestStat       = [];
bestBitstream  = [];

rateBPOVPerAxis   = [0 0 0];

%Checks if the testMode is correct
if (sum(enc.params.testMode) == 0)
    error('At least one mode should be tested -> params.testMode');
end

%Iterate to find the best axis
for (k = 1:1:3)

    tStart_Axis = tic;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Splices the geoCube
    currAxis = axisArray(k);
    display(['Encoding ' currAxis ' axis...'])
    %geoCube = ptcld2Slices(enc.pointCloud.Location,currAxis,enc.pcLimit);
    geoCube = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Initializes the cabac.
    cabac = getCABAC();
    cabac = initCABAC(cabac, enc.params.BACParams);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Encodes the Geometry Cube.
    iStart = 1;
    iEnd   = enc.pcLimit + 1;%size(geoCube,3);
        
    cabac = encodeGeoCube(geoCube, enc, cabac, currAxis, iStart, iEnd);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Closes the cabac Bitstream.
    cabac.BACEngine = closeBitstreamBAC(cabac.BACEngine);
    
    %Get the size of the parameters.
    length_bitstreamParam = cabac.ParamBitstream.size();
        
    %Encodes the bitstream param.
    bitstreamParam = encodeBitstreamParam(cabac.ParamBitstream.data(1:cabac.ParamBitstream.p),enc.params);
    
    %Gets the bitstream header.
    bitstream = createBitstreamHeader(enc.pcLimit, currAxis, length_bitstreamParam);
    
    %Merges all bitstreams.
    bitstream = bitstream.merge(bitstreamParam);
    bitstream = bitstream.merge(cabac.BACEngine.bitstream);    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    totalRate = (ceil(bitstream.size() / 8) * 8) + 1;
    
    rateBPOVPerAxis(k) = totalRate / enc.numberOfOccupiedVoxels;
    if (totalRate < bestRate)
        bestAxis      = currAxis;
        bestRate      = totalRate;
        bestGeoCube   = [];
        bestBitstream = bitstream;
    end
    
    tEnd_Axis = toc(tStart_Axis);
    if (k == 1)
        disp(['Axis X - Rate = ' num2str(rateBPOVPerAxis(1),'%2.4f') ' bpov - Encoding Time = ' num2str(tEnd_Axis,'%2.1f') ' seconds.'])
    elseif (k == 2)
        disp(['Axis Y - Rate = ' num2str(rateBPOVPerAxis(2),'%2.4f') ' bpov - Encoding Time = ' num2str(tEnd_Axis,'%2.1f') ' seconds.'])
    elseif (k == 3)
        disp(['Axis Z - Rate = ' num2str(rateBPOVPerAxis(3),'%2.4f') ' bpov - Encoding Time = ' num2str(tEnd_Axis,'%2.1f') ' seconds.'])
    end
end

%Writes the encoder out.
enc.rate            = bestRate;
enc.rate_bpov       = bestRate / enc.numberOfOccupiedVoxels;
enc.bitstream       = bestBitstream;
enc.dimensionSliced = bestAxis;
enc.geometryCube    = bestGeoCube;

%Writes the bitstream.
bitstreamFile     = [enc.params.workspaceFolder enc.params.bitstreamFile];
disp(['Writing to file ' bitstreamFile ''])
bestBitstream.flushesToFile(bitstreamFile);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
