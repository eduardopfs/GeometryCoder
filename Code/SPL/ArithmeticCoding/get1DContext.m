%1D Context
%
%
% 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  ?
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
function contextNumber = get1DContext(A, pos, numberOfContexts)

A = double(A);

%Initialize all contexts as zeros.
c = zeros(1,16);

%Checks context's existence and gets it.
%Checks context 1
if (pos > 1)
    c(1) = A(pos - 1);    
end

%Checks context 2
if (pos > 2)
    c(2)  = A(pos - 2);
end

%Checks context 3
if(pos > 3)
    c(3)  = A(pos - 3);
end

%Checks context 4
if (pos > 4)
    c(4)  = A(pos - 4);
end

%Checks context 5
if (pos > 5)
    c(5)  = A(pos - 5);
end

%Checks context 6
if (pos > 6)
    c(6)  = A(pos - 6);
end

%Checks context 7
if (pos > 7)
    c(7)  = A(pos - 7);
end

%Checks context 8
if (pos > 8)
    c(8)  = A(pos - 8);
end

%Checks context 9
if (pos > 9)
    c(9)  = A(pos - 9);
end

%Checks context 10
if (pos > 10)
    c(10) = A(pos - 10);
end

%Checks context 11
if (pos > 11)
    c(11) = A(pos - 11);
end

%Checks context 12
if (pos > 12)
    c(12) = A(pos - 12);
end

%Checks context 13
if (pos > 13)
    c(13) = A(pos - 13);
end

%Checks context 14
if (pos > 14)
    c(14) = A(pos - 14);
end

%Checks context 15
if (pos > 15)
    c(15) = A(pos - 15);
end

%Checks context 16
if (pos > 16)
    c(16) = A(pos - 16);
end


p2 = [1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768];
p2c = p2 .* c;

contextNumber = sum(p2c(1:numberOfContexts));
%context       = c(1:numberOfContexts);
   