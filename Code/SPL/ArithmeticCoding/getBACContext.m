% BACContext - Binary Arithmetic Coding Context
% Definitions
% mps - Which bit is the MPS for this context (either '0' or '1')
% countMPS - the number of times MPS occurred
% totalCount - the total count (LPS + MPS)
%
% Eduardo Peixoto
% eduardopeixoto@ieee.org
% 31/01/2019
function s = getBACContext(mps, countMPS, totalCount)

s = struct('MPS',mps,...
           'countMPS',countMPS,...
           'totalCount',totalCount);

