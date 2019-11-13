% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = encodeImageBAC_withMask_3DContexts2(A,idx_i, idx_j,Yleft,cabac)

%This function uses the contexts in:
% cabac.BACContexts_3D

A = double(A);
%mask = double(mask);
w         = cabac.BACParams.windowSizeFor3DContexts;
padYleft  = padarray(Yleft,[w w]);
padA      = padarray(A,[3 3]);

maxValueContext = cabac.BACParams.maxValueContext;

currBACContext = getBACContext(false,maxValueContext/2,maxValueContext);

numberOfContexts = cabac.BACParams.numberOfContextsMasked;

%[sy sx] = size(A);
%sizeA   = size(A);

%[idx_i, idx_j] = find(mask');
for k = 1:1:length(idx_i)
    y = idx_j(k);
    x = idx_i(k);        %It only encodes it IF the mask says so.
    
    currSymbol        = A(y,x);
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
    
    %Encodes the current symbol using the current context probability.
    cabac.BACEngine = encodeOneSymbolBAC(cabac.BACEngine,currBACContext,currSymbol);
    
    %Updates the context.
    if (currSymbol == false)
        cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 1) = cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 1) + 1;
    else
        cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 2) = cabac.BACContexts_3D(contextNumberLeft, contextNumber2D + 1, 2) + 1;
    end
end
