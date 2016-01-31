clc, clear all;

step = 5e-3;
tx_Y = runge_solver(@lorenz, [0 50], step, [-1 0 -1]);
signal = tx_Y(:, 2);

e_i = 1;
for k = 0:0.1:5
    tau = [0, 150, 300];
    mag = [1, k, 0.5];

    m_signal = zeros(size(signal));

    for i = 1:min([ numel(tau), numel(mag) ])
        t = tau(i) + 1;
        m = mag(i);
        m_signal(t:end) = m_signal(t:end) + m*signal(1:end - t + 1);
    end

    % ---------------------------
    
    r_signal = m_signal;
    rx_Y = runge_solver(@lorenz, [0 50], step, [1 0 1], @(i, Yn) mix_value(i, Yn, r_signal));

    % ---------------------------

    x1 = tx_Y(:, 1);
    x2 = rx_Y(:, 1);

    x2_sh = zeros(size(x2));

    for tau = 1:1000
        x2_sh(1:end) = 0;
        x2_sh(1:(end - tau + 1)) = x2(tau:end);
        nom = mean(x1.*x2_sh) - mean(x1)*mean(x2_sh);
        den = sqrt((mean(x1.^2) - mean(x1)^2)*(mean(x2_sh.^2) - mean(x2_sh)^2));
        Rx1x2(tau) = nom/den;
    end

    [C, I] = max(Rx1x2);
    etha(e_i) = C;
    pp(e_i) = I;
    e_i = e_i + 1;
end

figure(1);
plot(etha);
grid on;

figure(2);
plot(pp);
grid on;