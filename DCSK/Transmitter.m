classdef Transmitter < handle
    
    properties(Access = private)
        globalConfig;
        userConfig;
    end
    
    methods
        
        function this = Transmitter(globalConfig, userConfig)
            this.globalConfig = globalConfig;
            this.userConfig = userConfig;
        end
        
        function signal = Transmit(data)
            gCfg = this.globalConfig;
            
            data = data(:);
            blocksNumber = ceil(numel(data)/gCfg.Ns);
            alignedData = zeros(blocksNumber*gCfg.Ns, 1);
            alignedData(1:numel(data)) = data;
            dataBlocks = reshape(alignedData, gCfg.Ns, []);
            
            signal = reshape(symbols, 1, []);
        end
        
    end
    
    methods(Access = private)
        
        function symbol = MakeSymbol(this, dataBlock)
            % Make OFDM-DCSK symbol
            
            % Spreding sequence
            ss = this.userConfig.chaoticGenerator.Generate(this.globalConfig.beta);
            pilotPattern = this.GetPilotPattern();
            
            % Insert pilots
            data = vertcat(1, data(1:4), 1, data(5:end), 1);
            symbol = ifft(diag(data)*repmat(ss, 11, 1));
            
        end
        
        function result = InsertPilots(this, dataBlock)
            gCfg = this.globalConfig;
            dataBlocksNumber = size(dataBlock, 2);
            usersNumber = gCfg.P;
            shSubCarriersNumber = gCfg.Ns;
            shSubBandsNumber = gCfg.Np - 1;
            shSubBandSize = shSubCarriersNumber/shSubBandsNumber;
            shSubBandsSizes = zeros(shSubBandsNumber, 1);
            
            pSubBand = zeros(usersNumber, 1);
            pSubBand(this.userConfig.number) = 1;
            pSubBand = repmat(pSubBand, 1, dataBlocksNumber);
            
            shSubBandsSizes(:) = floor(shSubBandSize);
            shSubBandsSizes(end) = ceil(shSubBandSize);
            
            result = vertcat(pSubBand, dataBlock);
        end
                
        function alignedDataBlock = AlignDataBlock(this, dataBlock)
            alignedDataBlock = zeros(this.globalConfig.Ns, 1);
            alignedDataBlock(1:numel(dataBlock)) = dataBlock;
        end
        
    end
    
end