% Spectral Output with Quantization Noise Demonstration

% Signal Parameters
Fs = 22; % Sampling frequency (Hz)
N = 1000; % Number of samples
T = 1/Fs; % Sampling period (s)
t = 0:T:(N/Fs)-T; % Time vector
f = 8; % Frequency of input sine wave (Hz)
A = 1; % Amplitude of input sine wave
An = 0.1; % Noise amplitude

% Generate a continuous sine wave
%x_signal = A*sin(2*pi*f*t);
%x_signal = A*sin(2*pi*f*t) + A/10*sin(2*pi*f*5200*t);
x_signal = A*sin(2*pi*f*t) + A/10*sin(2*pi*f*10*t);
%x_noise = An*randn(size(t));
x_noise = An*sin(2*pi*50*t);
x_continuous = x_signal + x_noise;

% Calculate how noise shows in spectrum view
% Noise power is distributed to all frequency bins
nf = 10 * log10((An^2)/N);
disp(['Calculated signal noise component floor ', num2str(nf),' dB']);

% If sine wave cycle isn't exact multiple of sample window, then there are 
% transition effects. FFT assumes that the signal repeats itself infinitely
% and if starting point and end point do not meet, there is signal jump
window = hann(length(t));
x_continuous = x_continuous .* window';
x_continuous = x_continuous / (sum(window)/N); %normalize for window weights

% Zero-padding is one mechanism to control "spectrum leakage"
% Ideally single freaquency would be a thin peak, but computation
% makes it wider at bottom (try signal without windowinmg and zero padding)
N_original = length(x_continuous); % Original signal length
N_padded = 2^nextpow2(N_original + 1024); % Desired length after zero-padding
x_continuous = [x_continuous, zeros(1, N_padded - N_original)]; % Append zeros

% Quantization plays the effect of ADC transforming the continuous
% analog signal into discrete voltage levels 1 LSB apart
nBits = 10; % Number of bits for quantization
L = 2^nBits; % Number of quantization levels
delta = (2*A) / L; % Quantization step size, assuming signal covers full adc range
x_quantized = round(x_continuous/delta)*delta;

% Compute FFT, note switching to capital X in example notation
X_continuous_ = abs(fft(x_continuous));
X_quantized_ = abs(fft(x_quantized));

% Normalize the FFT amplitude
X_continuous = 2 * X_continuous_ / N;
X_quantized = 2 * X_quantized_ / N;

% Add a small offset to avoid log(0)
epsilon = 1e-10;
X_continuous = X_continuous + epsilon;
X_quantized = X_quantized + epsilon;

% switch on/off following lines if you use / do not use zero padding
%frequencies = (0:length(t)-1)*Fs/length(t); % Frequency vector
frequencies = (0:N_padded-1)/N_padded * Fs; % Frequency vector, where fs is the sampling frequency

signal_amplitude_continuous = max(X_continuous);
signal_amplitude_quantized = max(X_quantized);
signal_amplitude_continuous_db = 20*log10(signal_amplitude_continuous);
signal_amplitude_quantized_db = 20*log10(signal_amplitude_quantized);

% estimate the noise floor
noise_floor_estimate_continuous = median(X_continuous);
noise_floor_estimate_quantized = median(X_quantized);

snr_db = 20*log10(noise_floor_estimate_quantized);

% Plot
figure;

% Plot FFT of continuous sine wave
subplot(2,1,1);
plot(frequencies, 20*log10(X_continuous));
title('Spectrum of Continuous Sine Wave');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
xlim([0 Fs/2]);

% Plot FFT of quantized sine wave
subplot(2,1,2);
plot(frequencies, 20*log10(X_quantized));
title(['Spectrum of Quantized Sine Wave (', num2str(nBits), ' bits)']);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
xlim([0 Fs/2]);

% Draw horizontal line denoting the noise floor
noise_floor_level = 20*log10(noise_floor_estimate_quantized);
xlim_vals = xlim; % Get current x-axis limits
line(xlim_vals, [noise_floor_level noise_floor_level], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1);

disp(['Simulation noise floor (signal noise and quantization noise) for a ', num2str(nBits), '-bit ADC: ', num2str(snr_db), ' dB']);

