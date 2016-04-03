classdef CombTypeMapper < handle
    
    properties(Access = private)
        globalConfig;
    end
    
    properties(SetAccess = private)
        matrix;
    end
    
    methods
        
        function this = CombTypeMapper(globalConfig)
            this.globalConfig = globalConfig;
            this.matrix = this.CalculateMatrix();
        end
        
    end
    
    methods(Access = private)
        
        function result = CalculateMatrix(this)
            cfg = this.globalConfig;
            subBandSizes = vertcat(this.GetPrivateSubBandSizes(), this.GetSharedSubBandSizes());
            PM = this.GetSubBandPermuteMatrix(numel(subBandSizes));
            
            hSubBandIndices = this.CalculateIndices(subBandSizes);
            vSubBandIndices = PM.'*this.CalculateIndices(PM*subBandSizes);
            
            SubBandsInfo = horzcat(hSubBandIndices, vSubBandIndices, subBandSizes);
            
            result = zeros(cfg.N);
            
            for i = SubBandsInfo.'
                hIndex = i(1);
                vIndex = i(2);
                size = i(3);
                result(vIndex:vIndex + size - 1, hIndex:hIndex + size - 1) = eye(size);
            end
        end
        
        function result = GetPrivateSubBandSizes(this)
            cfg = this.globalConfig;
            result = repmat(cfg.P, cfg.Np, 1);
        end
        
        function result = GetSharedSubBandSizes(this)
            cfg = this.globalConfig;
            sharedSubBandsNumber = cfg.Np - 1;
            sharedSubBandsSize = cfg.Ns/sharedSubBandsNumber;
            result = zeros(sharedSubBandsNumber, 1);
            result(:) = floor(sharedSubBandsSize);
            result(end) = ceil(sharedSubBandsSize);
        end
        
        function result = CalculateIndices(~, sizes)
            length = numel(sizes);
            result = ones(length, 1);
            for i = 2:length
                result(i) = result(i - 1) + sizes(i - 1);
            end
        end
        
        function result = GetSubBandPermuteMatrix(~, size)
            result = zeros(size);
            result(:, 1) = 1;
            
            for i = 2:size
                result(i:end, :) = circshift(result(i:end, :), 2, 2);
            end
            
            if mod(result, 2) == 0
                result(result/2+1:end, :) = circshift(result(result/2+1:end, :), 1, 2);
            end
            
            result = result.';
        end
        
    end
    
end