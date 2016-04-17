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
            % Spreading in time.
            result = kron(result, ones(1, cfg.beta));
            chaoticSequence = user.chaoticGenerator.Generate(cfg.beta*size(dataBlock, 2));
            chaoticSequence = repmat(chaoticSequence, 1, cfg.N);
            result = result.*chaoticSequence.';
            result = ifft(ifftshift(result, 1));
        end
        
        function result = SerialToParallel(this, data)
            cfg = this.globalConfig;
            result = Util.align(data, cfg.Ns);
            result = reshape(result, cfg.Ns, []);
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
        
    end
    
end