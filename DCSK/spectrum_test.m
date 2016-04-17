clc, clear all, close all;

cfg.beta = 20; % Spreading factor
cfg.P = 1; % Number of users
cfg.N = 16; % Total number of subcarriers
cfg.Np = 3; % Number of private subcarriers for one user
cfg.Ns = cfg.N - cfg.P*cfg.Np; % Number of shared public subcarriers

mapper = CombTypeMapper(cfg);
user1 = User(1, CPFChaoticGenerator(0.03));
tx1 = Transmitter(cfg, user1, mapper);

% data1 = [-1 -1 1 1 1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 1 1 1 1 1 -1 1];
data1 = zeros(1, 23);
disp(reshape(Util.align(data1, cfg.Ns), cfg.Ns, []));

signal = tx1.Transmit(data1);

N1 = numel(signal) - cfg.N;
ffts1 = zeros(cfg.N, N1);

for i = 0:N1 - 1
    ffts1(:, i + 1) = fftshift(abs(fft(signal((1:cfg.N) + i).')), 1);
end

N2 = numel(signal)/cfg.N - 1;
ffts2 = zeros(cfg.N, N2);

for i = 0:N2 - 1
    ffts2(:, i + 1) = fftshift(abs(fft(signal((1:cfg.N) + i*cfg.N).')), 1);
end

subplot(2, 1, 1);
imagesc(ffts1);
title('Not aligned');
xlabel('Time');
ylabel('Subcarrier');

subplot(2, 1, 2);
imagesc(ffts2);
title('Aligned');
xlabel('Time');
ylabel('Subcarrier');