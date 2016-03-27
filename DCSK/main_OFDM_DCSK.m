clc, clear all;

% TRANSMITTER
% Parallel data
p_data = [1, -1, -1, 1, 1, 1, -1, 1].';

% Insert pilot
p_data = vertcat(1, p_data(1:4), 1, p_data(5:end), 1);

% Spreding sequence
ss = CPF(20, 0.03).';

symbol = ifft(diag(p_data)*repmat(ss, 11, 1));
r = reshape(symbol, 1, []);



% RECEIVER
rx_p_data = reshape(r, 11, []);
rx_symbol = fft(rx_p_data);
R = vertcat(rx_symbol(1,:), rx_symbol(5,:), rx_symbol(end,:));
Y = vertcat(rx_symbol(2:5, :), rx_symbol(7:end - 1, :));
D = real(sum(R*Y'));

D(D > 0) = 1;
D(D < 0) = -1;