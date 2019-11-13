% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [bitstreamParam , bitstream_out] = decodeBitstreamParam(bitstream, nSymbols, params)

numberOfContexts = params.BACParams.numberOfContextsParams;

BACEngineDecoder           = getBACDecoder(params.BACParams.m);
BACEngineDecoder.bitstream = bitstream;
BACEngineDecoder           = initBACDecoder(BACEngineDecoder);

countContexts   = initCountContexts_1D(numberOfContexts);
maxValueContext = params.BACParams.maxValueContext;
currBACContext  = getBACContext(false,maxValueContext/2,maxValueContext);

msg = zeros(1,nSymbols,'logical');

for k = 1:1:nSymbols  
    contextNumber = get1DContext(msg, k, numberOfContexts);
    
    %Gets the current count for this context.
    currCount = countContexts(contextNumber + 1,:);
    
    %Gets the current BAC context for this context
    p1s = currCount(2) / (sum(currCount));
    
    if (p1s > 0.5)
        currBACContext.MPS = true;
        currBACContext.countMPS = floor(p1s * maxValueContext);
    else
        currBACContext.MPS = false;
        currBACContext.countMPS = floor((1 - p1s) * maxValueContext);
    end
    
    %Encodes the current symbol using the current context probability.
    [BACEngineDecoder, currSymbol] = decodeOneSymbolBAC(BACEngineDecoder, currBACContext);
    
    %Gets the symbol.
    msg(k) = currSymbol;
    
    %Updates the context.
    if (currSymbol == false)
        countContexts(contextNumber + 1,1) = countContexts(contextNumber + 1,1) + 1;
    else
        countContexts(contextNumber + 1,2) = countContexts(contextNumber + 1,2) + 1;
    end   
end

bitstream_out  = BACEngineDecoder.bitstream;

%Create the bistream param.
bitstreamParam                 = Bitstream(nSymbols);
bitstreamParam.data            = msg;
bitstreamParam.lengthBitstream = nSymbols;