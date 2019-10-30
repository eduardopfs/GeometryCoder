% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function cabac = initCABACDecoder(cabac, BACParams)
    
%Gets the parameters.
cabac.BACParams = BACParams;

%Initializes the engine
cabac.BACEngineDecoder = getBACDecoder(BACParams.m);

%Initializes the 2D contexts.
cabac.BACContexts_2D_Independent = initCountContexts_2D(BACParams.numberOfContextsIndependent);
cabac.BACContexts_2D_Masked      = initCountContexts_2D(BACParams.numberOfContextsMasked);

%Initializes the 3D contexts.
cabac.BACContexts_3D = initCountContexts_3D(BACParams.numberOf3DContexts , BACParams.numberOfContextsMasked);
cabac.BACContexts_3D_ORImages = initCountContexts_3D(BACParams.numberOf3DContexts , BACParams.numberOfContextsMasked);

%Initializes the Parameter Contexts
cabac.ParamBitstream = Bitstream(1024);
