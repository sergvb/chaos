clc, clear all;

% A = reshape(1:20, 4, []);
A = repmat((1:4).', 1, 5);
% disp(A);
B = ifftshift(A, 1);
% disp(B);
C = ifft(B);
% disp(C);
D = reshape(C, 1, []);
% disp(D);

d = D((1:4) + 7).';
disp(d);
E = fftshift(fft(d), 1);
disp(abs(E));
disp(E);
disp(angle(E)/pi);
disp(E * exp(1i*pi/2));