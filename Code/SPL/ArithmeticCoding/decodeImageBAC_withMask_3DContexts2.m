%The input A contains what I know about A.
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function [A, cabac] = decodeImageBAC_withMask_3DContexts2(A, idx_i, idx_j, Yleft, cabac)

%A    = double(A);
w        = cabac.BACParams.windowSizeFor3DContexts;
padYleft = padarray(Yleft,[w w]);
padA     = padarray(A,[3 3]);

maxValueContext = cabac.BACParams.maxValueContext;

currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);

numberOfContexts = cabac.BACParams.numberOfContextsMasked;

%[idx_i, idx_j] = find(mask');
for k = 1:1:length(idx_i)
    y = idx_j(k);
    x = idx_i(k);        %It only decodes it IF the mask says so.
    
    contextNumber2D   = get2DContext(padA, [y x], numberOfContexts);
    contextNumberLeft = getContextLeft(padYleft,[y x], w);
    
    %Gets the current count for this context.
    currCount = [0 0];
    currCount(1) = cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 1);
    currCount(2) = cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 2);
    
    %Gets the current BAC context for this context
    p1s = currCount(2) / (sum(currCount));
    
    if (p1s > 0.5)
        currBACContext.MPS = true;
        currBACContext.countMPS = floor(p1s * maxValueContext);
    else
        currBACContext.MPS = false;
        currBACContext.countMPS = floor((1 - p1s) * maxValueContext);
    end
    
    %Decodes the current symbol using the current context probability
    [cabac.BACEngineDecoder, currSymbol] = decodeOneSymbolBAC(cabac.BACEngineDecoder,currBACContext);
    
    A(y,x)        = currSymbol;          %Fills the decoded matrix.
    padA(y+3,x+3) = double(currSymbol);  %Fills the padded image to keep the context correct.
    
    %Updates the context.
    if (currSymbol == false)
        cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 1) + 1;
    else
        cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 2) + 1;
    end
    
end
