classdef Receiver < handle
    
    properties
        globalConfig;
        mapper;
        refPermuteMatrix;
    end
    
    methods
        
        function this = Receiver(globalConfig, mapper)
            this.globalConfig = globalConfig;
            this.mapper = mapper;
            this.refPermuteMatrix = this.CalculateRefPermuteMatrix();
        end
        
        function [R, Y] = Receive(this, signal)
            cfg = this.globalConfig;
            samplesBlocks = this.SerialToParallel(signal(:));
            result = fftshift(fft(samplesBlocks), 1);
            result = this.mapper.matrix.'*result;
            R = this.refPermuteMatrix*result(1:cfg.P*cfg.Np, :);
            Y = result((cfg.P*cfg.Np + 1):end, :);
        end
        
    end
    
    methods(Access = private)
        
        function result = SerialToParallel(this, samples)
            cfg = this.globalConfig;
            result = Util.align(samples, cfg.N);
            result = reshape(result, cfg.N, []);
        end
        
        function result = CalculateRefPermuteMatrix(this)
            cfg = this.globalConfig;
            mat = zeros(cfg.P, cfg.Np);
            mat(1, 1) = 1;
            mat = repmat(mat, cfg.Np, cfg.P);
            
            for i = 0:cfg.P-1
                cols = i*cfg.Np + (1:cfg.Np);
                mat(:, cols) = circshift(mat(:, cols), i, 1);
            end
            
            for i = 0:cfg.Np-1
                rows = i*cfg.P + (1:cfg.P);
                mat(rows, :) = circshift(mat(rows, :), i, 2);
            end
            
            result = mat.';
        end
        
    end
    
end