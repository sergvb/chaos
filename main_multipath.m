clc, clear all;

tau1 = 30;
tau2 = 952;

Y = runge_solver(@lorenz, [0 50], 5e-3, [-15 -3 -30]);
y1 = Y(:, 2);
src = zeros(size(Y));

r1 = y1;

r2 = zeros(size(y1));
r2(tau1:end) = r2(tau1:end) + y1(1:end - tau1 + 1);

r3 = zeros(size(y1));
r3(tau2:end) = r3(tau2:end) + y1(1:end - tau2 + 1);

t = 0:5e-3:50;
s1 = cos (2*pi*0.1*t);
figure(3);
plot (s1);
%sig = r1 + randn(size(r1)) ;%0.4*r2;% + 0.1*r3;
sig = r1 + s1' ;%+ 0.4*r2;% + 0.1*r3;


src(:, 2) = sig;
figure(1);
subplot(4, 1, 1);
plot(sig);
title('mix');
grid on;

% ---------------------------

Y2 = runge_solver(@lorenz, [0 50], 5e-3, [-15 -3 -30], src, [0 1 0]);
y2 = Y2(:, 2);

s = sig - y2;
src(:, 2) = s;
subplot(5, 1, 2);
plot(s);
title('mix - ray 1');
grid on;

Y3 = runge_solver(@lorenz, [0 50], 5e-3, [-15 -3 -30], src, [0 1 0]);
y3 = Y3(:, 2);

s = s - y3;
src(:, 2) = s;
subplot(5, 1, 3);
plot(s);
title('mix - ray 2');
grid on;

Y4 = runge_solver(@lorenz, [0 50], 5e-3, [-15 -3 -30], src, [0 1 0]);
y4 = Y4(:, 2);

s = s - y4;

subplot(5, 1, 4);
plot(s);
title('mix - ray 3');
grid on;

src(:, 2) = s;
Y5 = runge_solver(@lorenz, [0 50], 5e-3, [-15 -3 -30], src, [0 1 0]);
y5 = Y5(:, 2);

s = s - y5;

subplot(5, 1, 5);
plot(s);
title('mix - ray 4');
grid on;







figure(2);
subplot(4, 1, 1);
plot(r1);
title('ray 1');
grid on;

subplot(4, 1, 2);
plot(r2);
title('ray 2');
grid on;

subplot(4, 1, 3);
plot(r3);
title('ray 3');
grid on;

subplot(4, 1, 4);
plot(sig);
title('mix');
grid on;

% plot(r1, 'g--');
% hold on; plot(r2, 'r-.');
% hold on; plot(y2, 'b');
% grid on;

plot3(Y(:,1), Y(:,2), Y(:,3));
hold on; plot3(Y3(:,1), Y3(:,2), Y3(:,3), 'r--');
title('3D');
grid on;

% d = sqrt(sum((Y - Y2).^2, 2));
% 
% plot(d);
% 
% plot3(Y(1:400,1), Y(1:400,2), Y(1:400,3)); hold on; 
% plot3(Y2(1:400,1), Y2(1:400,2), Y2(1:400,3),'r-');
