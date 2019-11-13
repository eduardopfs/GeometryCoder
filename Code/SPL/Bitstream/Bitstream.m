% Bitstream class
%
% The bitstream class has the following attributes:
%   - data            - the data itself. This is an array of logical 
%                       elements.
%   - p               - the pointer, i.e., where in the data it is 
%                       reading/writing.
%   - lengthBitstream - the actual size of the bitstream.
%   - lengthAllocated - the size it has already allocated for data.
%
% And it defines the following methods:
%   - function obj = Bitstream(lData)
%      -> Constructs a Bitstream with allocated size lData (default: 65536)               
%   - function s = size(obj)
%      -> Returns the size of the bitstream (i.e., lengthBitstream)
%   - function obj = putBit(obj,bit)
%      -> Adds a bit to the bitstream, possibly growing it.
%   - function vec = getBytestream(obj)
%      -> Gets a bytestream from the bitstream (i.e., merges the bits in 8
%         bits each, storing it as uint8)
%   - function flushesToFile(obj,filename)
%      -> Writes the bitstream to a file.
%   - function obj = loadBitstream(obj,filename)
%      -> Loads a bitstream from a file.
%   - function [obj, bit] = read1Bit(obj)
%      -> Reads 1 bit from the bitstream, updating the pointer p.
%   - function obj = merge(obj,obj2)
%      -> Merges two bitstream objects
%   - function obj = cutBitstream(obj,len)
%      -> Cuts a bitstream object, reducing its length.
%   - function obj = setPointer(obj,pointer)
%      -> Sets the internal pointer p
%
% Author: Eduardo Peixoto
% E-mail: eduardopeixoto@ieee.org
classdef Bitstream
    
    properties
        data
        p
        lengthBitstream
        lengthAllocated
    end
    
    methods
        %Constructor
        function obj = Bitstream(lData)
            %Default value
            if (nargin == 0)
                lData = 65536;
            end
            
            obj.data            = zeros(1,lData,'logical');
            obj.p               = 0;
            obj.lengthBitstream = 0;
            obj.lengthAllocated = lData;
        end
        
        %Returns the bitstream size.
        function s = size(obj)
            s = obj.lengthBitstream();
        end
        
        %Add a bit to the Bitstream.
        function obj = putBit(obj,bit)
            %Grows the bitstream if needed.
            if (obj.p + 1 > obj.lengthAllocated)
                obj.lengthAllocated = obj.lengthAllocated * 2;
                obj.data(1,obj.lengthAllocated) = false;
            end
            
            %Insert the bit.
            obj.p               = obj.p + 1;
            obj.data(obj.p)     = logical(bit);
            obj.lengthBitstream = obj.lengthBitstream + 1;            
        end
        
        %Gets a bytestream.
        function vec = getBytestream(obj)
            
            N = 1 + ceil(obj.lengthBitstream / 8);
            vec = zeros(1,N,'uint8');
            
            switch (mod(obj.lengthBitstream,8))
                case 0
                    firstByte = uint8(224);
                    
                case 1
                    firstByte = uint8(231);
                    
                case 2
                    firstByte = uint8(230);
                    
                case 3
                    firstByte = uint8(229);
                    
                case 4
                    firstByte = uint8(228);
                    
                case 5
                    firstByte = uint8(227);
                    
                case 6
                    firstByte = uint8(226);
                    
                case 7
                    firstByte = uint8(225);
                    
                otherwise
                    firstByte = uint8(0);
            end
            
            vec(1) = firstByte;
            
            w = [128 64 32 16 8 4 2 1];
            
            for k = 1:1:(N-1)
                if (k*8 <= obj.lengthAllocated)
                    t = obj.data((k-1)*8 + 1: k*8);
                else
                    %read what I can.
                    t = obj.data((k-1)*8 + 1: end);
                    %Stretches it to 8 bits.
                    t(8) = 0;
                end
                byte = uint8(sum(t .* w));
                vec(k+1) = byte;               
            end
            
        end
        
        %Flushes the bitstream to file.
        function flushesToFile(obj,filename)
            %Gets the bytevector
            byteVector = obj.getBytestream();
            
            %Writes the file.
            fid = fopen(filename,'wb');
            fwrite(fid,byteVector,'uint8');
            fclose(fid);
        end
        
        %Loads bitstream from file.
        function obj = loadBitstream(obj,filename) 
            %Opens it and gets the bytestream
            fid = fopen(filename,'rb');
            [byteVector,nBytes] = fread(fid);
            fclose(fid);
            
            %Takes the firstByte
            firstByte = byteVector(1);
            firstNibble = bitand(firstByte,240); %Logical AND with 0xF0
            if (firstNibble ~= 224)
                error('This is not an acceptable bitstream. Bitstream should start with 0xE.');
            end
            
            leftOverBits = bitand(firstByte,15); %This is the number of bits, at the tail end, that is NOT a part of the bitstream.
            
            %Prepares the current bitstream to fit this loaded bitstream.
            lData               = (nBytes - 1) * 8;
            obj.data            = zeros(1,lData,'logical');
            obj.p               = 0;
            obj.lengthBitstream = lData - leftOverBits;
            obj.lengthAllocated = lData;
            
            for k = 1:1:(nBytes - 1)
                currByte = byteVector(k + 1);
                
                %Performs the dec2bin conversion
                v8 = (bitand(currByte,[128 64 32 16 8 4 2 1]) ~= 0);
                
                %Attaches it to the bitstream. 
                obj.data( 8 * (k - 1) + 1: 8 * k ) = v8;                
            end            
            
        end
        
        %Reads 1 bit.
        %It should be used as: 
        %  [bitstream, bit] = bitstream.read1Bit();
        % This is not the prettiest way to do it, but I wanted to avoid a
        % handle.
        function [obj, bit] = read1Bit(obj)
            obj.p = obj.p + 1;
            %if (obj.p > obj.lengthBitstream)
            %    error('Attempt to read a non-existing bit!');
            %end
            
            bit = obj.data(obj.p);
        end
        
        %Merge different bitstreams.
        function obj = merge(obj,obj2)
            N1 =  obj.lengthBitstream;
            N2 = obj2.lengthBitstream;
            
            N = N1 + N2;
            
            %Grow my bitstream if needed.
            if (N > obj.lengthAllocated)                
                obj.data(1,N) = false;
                obj.lengthAllocated = N;
            end
            
            %Merge the data.
            obj.data(obj.p + 1: obj.p + N2) = obj2.data(1:N2);
            obj.p                           = obj.p + N2;
            obj.lengthBitstream             = N;
            
        end
        
        %Cuts the current bitstream starting from p+1, taking len bits.
        function obj = cutBitstream(obj,len)
            obj.data            = obj.data(obj.p + 1 : obj.p + len);
            obj.p               = 0;
            obj.lengthBitstream = len;
            obj.lengthAllocated = len;
        end
        
        %Sets the internal pointer
        function obj = setPointer(obj,pointer)
            obj.p = pointer;
        end
                
    end %end methods.
    
end %end class
        