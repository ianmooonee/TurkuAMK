%Read data
data = readtable('ecg.txt');
data = table2array(data);    

% Signal Parameters
Fs = 360; % Sampling frequency (Hz)
N = length(data); % Number of samples
T = 1/Fs; % Sampling period (s)
t = 0:T:(N/Fs)-T; % Time vector

%Perform FFT
D = abs(fft(data));
frequencies = (0:length(t)-1)*Fs/length(t); % Frequency vector

% Plot FFT of quantized sine wave
subplot(2,1,2);
plot(frequencies, 20*log10(D));
title('Signal Spectrum ');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
xlim([0 Fs/2]);

%Filter
%dF=filter(Hd, data);
dF = conv(data, Hd, 'same');
plot(dF);
DF = abs(fft(dF));
plot(frequencies, 20*log10(DF));
xlim([0 Fs/2]);