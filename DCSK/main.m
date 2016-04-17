clc, clear all;

cfg.beta = 150; % Spreading factor
cfg.P = 2; % Number of users
cfg.N = 16; % Total number of subcarriers
cfg.Np = 3; % Number of private subcarriers for one user
cfg.Ns = cfg.N - cfg.P*cfg.Np; % Number of shared public subcarriers

mapper = CombTypeMapper(cfg);
user1 = User(1, CPFChaoticGenerator(0.03));
user2 = User(2, CPFChaoticGenerator(0.05));
tx1 = Transmitter(cfg, user1, mapper);
tx2 = Transmitter(cfg, user2, mapper);
rx = Receiver(cfg, mapper);

data1 = [-1 -1 1 1 1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 1 1 1 1 1 -1 1];
data2 = [-1 1 -1 1 -1 1 1 1 -1 -1 1 -1 1 1 1 1 -1 -1 1 -1 -1 1 -1 ];

disp(reshape(Util.align(data1, cfg.Ns), cfg.Ns, []));

signal = tx1.Transmit(data1); % + tx2.Transmit(data2);

signal = [zeros(1, cfg.N*cfg.beta), signal, zeros(1, cfg.N*cfg.beta)];
signal = Util.align(signal, cfg.N*cfg.beta);
tmp = signal;

for delay = (0:32) %* cfg.N
    signal = circshift(tmp, -delay, 1);
    signal = reshape(signal, cfg.N, []);
    
    iterationsNumber = size(signal, 2) - cfg.beta;
    D = zeros(cfg.Ns, iterationsNumber);
%     P = zeros(cfg.Np, iterationsNumber);
    
    for i = 1:iterationsNumber
        fftbuf = signal(:, (0:cfg.beta - 1) + i);
        [R, Y] = rx.Receive(fftbuf);

%         R = abs(R);
%         Y = abs(Y);
        
%         D(:, i) = real(R(1, :) * Y' + R(2, :) * Y' + R(3, :) * Y');
        T = R(1, :) * Y' + R(2, :) * Y' + R(3, :) * Y';
        D(:, i) = real(T) + imag(T);
%         T1 = angle(R(1:cfg.Np, :) * R(1:cfg.Np, :)');
%         T1 = angle(abs(R(1:cfg.Np, :)) * abs(R(1:cfg.Np, :).'));
%         P(:, i, 1) = T1(:, 1);
%         P(:, i, 2) = T1(:, 2);
%         P(:, i, 3) = T1(:, 3);
    end
    
    Dnorm = 2/(3*cfg.beta) * D';
    Dth = Dnorm;
    Dth(Dth > eps) = 1;
    Dth(Dth < -eps) = -1;
    
    figure(1);
    for p = 1:cfg.Ns
        subplot(cfg.Ns, 1, p);
        plot([Dnorm(:, p), Dth(:, p)], 'LineWidth', 2);
        title(['Shared subcarrier ' num2str(p)]);
        ylim([-1.1 1.1]);
        xlim([1 iterationsNumber]);
        grid on;
    end
    
%     P = permute(P, [2 1 3]);
%     P = reshape(P, [], cfg.Np*3);
%     Pnorm = 2/cfg.beta * P;
%     
%     figure(2);
%     for p = 1:cfg.Np*3
%         subplot(cfg.Np, 3, p);
%         plot(Pnorm(:, p), 'LineWidth', 2);
%         title(['Private subcarrier ' num2str(p)]);
% %         ylim([-1.1 1.1]);
%         xlim([1 iterationsNumber]);
%         grid on;
%     end
    
    drawnow;
    waitforbuttonpress;
    % pause(0.5);
end


