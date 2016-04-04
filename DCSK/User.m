classdef(Sealed) User < handle
    
    properties(SetAccess = private)
        index;
        chaoticGenerator;
    end
    
    methods
        
        function this = User(index, chaoticGenerator)
            this.index = index;
            this.chaoticGenerator = chaoticGenerator;
        end
        
    end
    
end