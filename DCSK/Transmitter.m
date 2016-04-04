classdef Transmitter < handle
    
    properties(Access = private)
        globalConfig;
        userConfig;
        mapper;
    end
    
    methods
        
        function this = Transmitter(globalConfig, userConfig, mapper)
            this.globalConfig = globalConfig;
            this.userConfig = userConfig;
            this.mapper = mapper;
        end
        
        function signal = Transmit(this, data)
            dataBlocks = this.SerialToParallel(data(:));
            symbol = this.MakeSymbol(dataBlocks);
            signal = reshape(symbol, 1, []);
        end
        
    end
    
    methods(Access = private)
        
        function result = MakeSymbol(this, dataBlock)
            % Make OFDM-DCSK symbol
            cfg = this.globalConfig;
            user = this.userConfig;
            
            result = this.InsertPilots(dataBlock);
            result = this.SpredInTime(result);
            chaoticSequence = user.chaoticGenerator.Generate(cfg.beta*size(dataBlock, 2));
            chaoticSequence = chaoticSequence.';
            chaoticSequence = repmat(chaoticSequence, cfg.N, 1);
            result = result.*chaoticSequence;
            result = ifft(result);
        end
        
        function result = SerialToParallel(this, data)
            cfg = this.globalConfig;
            
            bitsNumber = numel(data);
            blocksNumber = ceil(bitsNumber/cfg.Ns);
            alignedData = zeros(blocksNumber*cfg.Ns, 1);
            alignedData(1:bitsNumber) = data;
            result = reshape(alignedData, cfg.Ns, []);
        end
        
        function result = InsertPilots(this, dataBlock)
            cfg = this.globalConfig;
            
            pSubBand = zeros(cfg.P, 1);
            % Inserting the marker of a reference signal for the
            % particular user.
            pSubBand(this.userConfig.index) = 1;
            pSubBand = repmat(pSubBand, cfg.Np, size(dataBlock, 2));
            
            result = vertcat(pSubBand, dataBlock);
            
            % Distributing the private subcarriers according to the
            % comb-type pattern.
            result = this.mapper.matrix*result;
        end
        
        function result = SpredInTime(this, dataBlocks)
            cfg = this.globalConfig;
            dataBlocksNumber = size(dataBlocks, 2);
            
            matrix = zeros(dataBlocksNumber, dataBlocksNumber*cfg.beta);
            matrix(:, 1:cfg.beta) = 1;
            
            for i = 2:dataBlocksNumber
                matrix(i:end, :) = circshift(matrix(i:end, :), cfg.beta, 2);
            end
            
            result = (matrix.'*dataBlocks.').';
        end
        
    end
    
end