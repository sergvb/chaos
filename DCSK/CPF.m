function x = CPF(n, x0)

x = zeros(n, 1);
x(1) = x0;

for k = 1:(n - 1)
    x(k + 1) = 1 - 2*x(k).^2;
end

end