function Y = runge_solver(equation, tspan, h, y0, prepare)
    t0 = tspan(1);
    tfinal = tspan(end);
    time = t0:h:tfinal;

    M = numel(y0);
    N = numel(time);
    Y = zeros(N, M);
    Y(1, :) = y0;

    for i = 1:N - 1
        t = time(i);
        yn = Y(i, :).';
        
        if nargin > 4
            yn = prepare(i, yn);
        end

        k1 = equation(t, yn);
        k2 = equation(t + h/2, yn + k1*h/2);
        k3 = equation(t + h/2, yn + k2*h/2);
        k4 = equation(t + h, yn + k3*h);
        
        Y(i + 1, :) = (yn + h/6*(k1 + 2*k2 + 2*k3 + k4)).';
    end
end

