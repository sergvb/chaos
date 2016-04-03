classdef(Sealed) User < handle
    
    properties(SetAccess = private)
        number;
        chaoticGenerator;
    end
    
    methods
        
        function this = User(number, chaoticGenerator)
            this.number = number;
            this.chaoticGenerator = chaoticGenerator;
        end
        
    end
    
end