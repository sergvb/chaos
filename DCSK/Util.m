classdef Util
    
    methods(Static)
        
        function result = align(vector, blockSize)
            length = numel(vector);
            blocksNumber = ceil(length/blockSize);
            result = zeros(blocksNumber*blockSize, 1);
            result(1:length) = vector;
        end
        
    end
    
end