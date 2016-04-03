clc, clear all;

cfg = globalConfiguration();

% TRANSMITTER
% Parallel data
p_data = [1, -1, -1, 1, 1, 1, -1, 1].';



% RECEIVER
rx_p_data = reshape(r, 11, []);
rx_symbol = fft(rx_p_data);
R = vertcat(rx_symbol(1,:), rx_symbol(5,:), rx_symbol(end,:));
Y = vertcat(rx_symbol(2:5, :), rx_symbol(7:end - 1, :));
D = real(sum(R*Y'));

D(D > 0) = 1;
D(D < 0) = -1;