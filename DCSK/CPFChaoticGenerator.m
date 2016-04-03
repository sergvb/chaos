classdef CPFChaoticGenerator < handle

    properties(Access = private)
        nextInitValue;
    end
    
    methods
    
        function this = CPFChaoticGenerator(initValue)
            this.nextInitValue = initValue;
        end
        
        function sequence = Generate(this, size)
            tmp = this.CPF(size + 1, this.nextInitValue);
            this.nextInitValue = tmp(end);
            sequence = tmp(1:end - 1);
        end
        
    end
    
    methods(Access = private)
        
        function x = CPF(~, n, x0)
            % Chebyshev polynomial function

            x = zeros(n, 1);
            x(1) = x0;

            for k = 1:(n - 1)
                x(k + 1) = 1 - 2*x(k).^2;
            end

        end
        
    end
    
end