function [ cfg ] = globalConfiguration()

% Spreading factor
cfg.beta = 20;

% Number of users
cfg.P = 1;
% Total number of subcarriers
cfg.N = 16;
% Number of private subcarriers for one user
cfg.Np = 3;
% Shared public subcarriers
cfg.Ns = cfg.N - cfg.P*cfg.Np;

end