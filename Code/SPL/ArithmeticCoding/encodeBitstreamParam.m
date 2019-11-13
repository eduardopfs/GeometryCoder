% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function bitstream = encodeBitstreamParam(msg,params)

numberOfContexts = params.BACParams.numberOfContextsParams;

BACEngine     = getBACEncoder(params.BACParams.m);
countContexts = initCountContexts_1D(numberOfContexts);

maxValueContext = params.BACParams.maxValueContext;

currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);
nSymbols = length(msg);

for k = 1:1:nSymbols
    currSymbol    = msg(k);
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
    BACEngine = encodeOneSymbolBAC(BACEngine,currBACContext,currSymbol);
    
    %Updates the context.
    if (currSymbol == false)
        countContexts(contextNumber + 1,1) = countContexts(contextNumber + 1,1) + 1;
    else
        countContexts(contextNumber + 1,2) = countContexts(contextNumber + 1,2) + 1;
    end
    
    
end

BACEngine = closeBitstreamBAC(BACEngine);
bitstream = BACEngine.bitstream;
