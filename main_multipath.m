clc, clear all;

tau1 = 2123;
tau2 = 952;

Y1 = runge_solver(@lorenz, [0 50], 5e-3, [-15 -3 -30]);
ray1 = Y1(:, 2);

ray2 = zeros(size(ray1));
ray2(tau1:end) = ray2(tau1:end) + ray1(1:end - tau1 + 1);

ray3 = zeros(size(ray1));
ray3(tau2:end) = ray3(tau2:end) + ray1(1:end - tau2 + 1);

m_signal = ray1 + 0.4*ray2 + 0.1*ray3;

% ---------------------------

src = zeros(size(Y1));

r_signal = m_signal;

src(:, 2) = r_signal;
Y2 = runge_solver(@lorenz, [0 50], 5e-3, [10 0 1], src, [0 1 0]);
y2 = Y2(:, 2);

r_signal = r_signal - y2;
rs_minus_r1 = r_signal;

src(:, 2) = r_signal;
Y3 = runge_solver(@lorenz, [0 50], 5e-3, [10 0 1], src, [0 1 0]);
y3 = Y3(:, 2);

r_signal = r_signal - y3;
rs_minus_r2 = r_signal;

src(:, 2) = r_signal;
Y4 = runge_solver(@lorenz, [0 50], 5e-3, [10 0 1], src, [0 1 0]);
y4 = Y4(:, 2);

r_signal = r_signal - y4;
rs_minus_r3 = r_signal;

src(:, 2) = r_signal;
Y5 = runge_solver(@lorenz, [0 50], 5e-3, [10 0 1], src, [0 1 0]);
y5 = Y5(:, 2);

r_signal = r_signal - y5;
rs_minus_a = r_signal;

% ---------------------------

p_number = 5;
figure(1);
subplot(p_number, 1, 1);
plot(m_signal);
title('mix');
grid on;

subplot(p_number, 1, 2);
plot(rs_minus_r1);
title('mix - ray 1');
grid on;

subplot(p_number, 1, 3);
plot(rs_minus_r2);
title('mix - ray 2');
grid on;

subplot(p_number, 1, 4);
plot(rs_minus_r3);
title('mix - ray 3');
grid on;

subplot(p_number, 1, 5);
plot(rs_minus_a);
title('mix - aditional');
grid on;

% plot(r1, 'g--');
% hold on; plot(r2, 'r-.');
% hold on; plot(y2, 'b');
% grid on;

% plot3(Y(:,1), Y(:,2), Y(:,3));
% hold on; plot3(Y2(:,1), Y2(:,2), Y2(:,3), 'r--');
% title('3D');
% grid on;