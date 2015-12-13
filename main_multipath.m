clc, clear all;

tx_Y = runge_solver(@lorenz, [0 50], 5e-3, [-1 -1 -1]);
signal = tx_Y(:, 2);

tau = [0, 120, 130, 150, 231];
mag = [1, 0.1, 0.2, 0.01, 0.5];
ray_number = min([ numel(tau), numel(mag) ]);

m_signal = zeros(size(signal));

for i = 1:ray_number
    t = tau(i) + 1;
    m = mag(i);
    m_signal(t:end) = m_signal(t:end) + m*signal(1:end - t + 1);
end

% ---------------------------

rx_sync_iteration_number = 20;
src = zeros(size(tx_Y));
r_signal = m_signal;

iter_result = zeros(numel(r_signal), rx_sync_iteration_number);

for i = 1:rx_sync_iteration_number
    src(1:numel(r_signal), 2) = r_signal;
    rx_Y = runge_solver(@lorenz, [0 50], 5e-3, [1 0 1], src, [0 1 0]);
    r_signal = r_signal - rx_Y(1:numel(r_signal), 2);
    iter_result(:, i) = r_signal;
end

% ---------------------------

max_row_number = 5;
plot_index = 1:rx_sync_iteration_number;
column_number = double(idivide(int32(rx_sync_iteration_number - 1), int32(max_row_number), 'fix') + 1);
row_number = double(idivide(int32(rx_sync_iteration_number - 1), int32(column_number), 'fix') + 1);
i_map = reshape(reshape(plot_index, [column_number, row_number]).', [1, rx_sync_iteration_number]);

figure(1);
for i = plot_index
    subplot(row_number, column_number, i_map(i));
    plot(iter_result(:, i));
    xlim([0, numel(r_signal)]);
    ylim([-2, 2]);
    title(['Iteration ' num2str(i)]);
    grid on;
end