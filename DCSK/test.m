clc, clear all;

% cfg = globalConfiguration();
% Spreading factor
cfg.beta = 20;
% Number of users
cfg.P = 2;
% Total number of subcarriers
cfg.N = 16;
% Number of private subcarriers for one user
cfg.Np = 3;
% Shared public subcarriers
cfg.Ns = cfg.N - cfg.P*cfg.Np;

mapper = CombTypeMapper(cfg);
user1 = User(1, CPFChaoticGenerator(0.03));
user2 = User(2, CPFChaoticGenerator(0.05));
tx1 = Transmitter(cfg, user1, mapper);
tx2 = Transmitter(cfg, user2, mapper);
rx = Receiver(cfg, mapper);

data1 = [-1 -1 1 1 1 -1 1 1 -1 1 1 1 -1];
data2 = [-1 1 -1 1 -1 1 1 1 -1 -1 -1 -1 1];
signal = tx1.Transmit(data1) + tx2.Transmit(data2);
% plot([real(signal).', imag(signal).']);

[R, Y] = rx.Receive(signal);

% D = kron(eye(cfg.P), ones(cfg.Np, 1)).'*R.'*Y;
% D(D >= 1) = 1;
% D(D <= -1) = -1;
% disp(D);