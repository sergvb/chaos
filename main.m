clc, clear all;

tau1 = 2123;
tau2 = 952;

Y = runge_solver(@lorenz, [0 50], 5e-3, [-15 -3 -30]);
y1 = Y(:, 2);
src = zeros(size(Y));

r1 = y1;

r2 = zeros(size(y1));
r2(tau1:end) = r2(tau1:end) + y1(1:end - tau1 + 1);

r3 = zeros(size(y1));
r3(tau2:end) = r3(tau2:end) + y1(1:end - tau2 + 1);


sig = r1 + 0.4*r2 + 0.1*r3;
src(:, 2) = sig;
figure(1);
subplot(4, 1, 1);
plot(sig);
grid on;

% ---------------------------

Y2 = runge_solver(@lorenz, [0 50], 5e-3, [10 0 1], src, [0 1 0]);
y2 = Y2(:, 2);

s = sig - y2;
src(:, 2) = s;
subplot(4, 1, 2);
plot(s);
grid on;

Y3 = runge_solver(@lorenz, [0 50], 5e-3, [10 0 1], src, [0 1 0]);
y3 = Y3(:, 2);

s = s - y3;
src(:, 2) = s;
subplot(4, 1, 3);
plot(s);
grid on;

Y4 = runge_solver(@lorenz, [0 50], 5e-3, [10 0 1], src, [0 1 0]);
y4 = Y4(:, 2);

s = s - y4;

subplot(4, 1, 4);
plot(s);
grid on;

figure(2);
subplot(4, 1, 1);
plot(r1);
grid on;

subplot(4, 1, 2);
plot(r2);
grid on;

subplot(4, 1, 3);
plot(r3);
grid on;

subplot(4, 1, 4);
plot(sig);
grid on;

% plot(r1, 'g--');
% hold on; plot(r2, 'r-.');
% hold on; plot(y2, 'b');
% grid on;

% plot3(Y(:,1), Y(:,2), Y(:,3));
% hold on; plot3(Y2(:,1), Y2(:,2), Y2(:,3), 'r--');
% title('3D');
% grid on;