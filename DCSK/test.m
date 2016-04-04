 clc, clear all;

cfg = globalConfiguration();
mapper = CombTypeMapper(cfg);
user = User(1, CPFChaoticGenerator(0.03));
tx = Transmitter(cfg, user, mapper);

data = (-1).^(1:33);
signal = tx.Transmit(data);
disp(data);
%plot([real(signal).', imag(signal).']);
plot(abs(fft(signal)).^2);