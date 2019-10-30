% dec = decodeGeometry2(dec)
%  
% This is the main decoder function. It opens the file, parses the
% bitstream, decodes the parameters and then calls the decodeGeoCube()
% function. Finally, it writes the output ply file. 
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function dec = decodeGeometry2(dec)

%Reads the bitstream from file. 
bitstreamFile = [dec.params.workspaceFolder dec.params.bitstreamFile];
bitstream = Bitstream(0);
bitstream = bitstream.loadBitstream(bitstreamFile);

%Parse the bitstream header
[limit, axis, length_header, length_BitstreamParam, bitstream] = parseBitstreamHeader(bitstream);

%Reads the bitstream parameters.
[bitstreamParam, bitstream] = decodeBitstreamParam(bitstream, length_BitstreamParam, dec.params);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initializes the cabac.
cabac = getCABAC();
cabac = initCABACDecoder(cabac, dec.params.BACParams);

cabac.ParamBitstream             = bitstreamParam;
bitstream                        = bitstream.cutBitstream(bitstream.lengthBitstream - bitstream.p);
cabac.BACEngineDecoder.bitstream = bitstream;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initializes the decoder
dec.pcLimit         = limit;
dec.dimensionSliced = axis;
dec.params.nBits    = log2(limit + 1);

%Initializes the decoded cube
dec.geometryCube = zeros(limit+1,limit+1,limit+1,'logical');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dec.geometryCube , cabac] = decodeGeoCube(dec.geometryCube , cabac, 1,limit + 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Decodes the location.
if (isempty(dec.params.outputPlyFile) == 0)
    locPoints = slices2Ptcld(dec.geometryCube, axis);
    pc        = pointCloud(locPoints);
    
    %file      = [dec.params.workspaceFolder dec.params.outputPlyFile];
    file      = dec.params.outputPlyFile;
    disp(['Writing output Ply to ' file ' .'])
    pcwrite(pc,file);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nSymbolsDecoded = cabac.BACEngineDecoder.nDecoded;
nVoxels         = sum(dec.geometryCube(:));

dec.nSymbolsDecoded = nSymbolsDecoded;
dec.nVoxelsDecoded  = nVoxels;

% nDecSymbolspov  = nSymbolsDecoded / nVoxels;
% complexity_file = [dec.params.workspaceFolder dec.params.sequence '_complexity.txt'];
% fid = fopen(complexity_file,'a');
% fprintf(fid,'%d\t%d\t%2.2f\n',nSymbolsDecoded,nVoxels,nDecSymbolspov);
% fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
