% hw3_1.m - 請完整寫出把三首歌都分出來的過程
clear all;close all;clc;

% Read in input audio file (wavread or audioread)
[y, Fs] = audioread('hw3_mix.wav');

% Filtering

N = 1001;
f1 = 400;
f2 = 750;
[y_low_pass, filter_low] = myFilter(y, Fs, N, 'Hamming', 'low-pass', f1);
[y_band_pass, filter_band] = myFilter(y, Fs, N, 'Hamming', 'bandpass', [f1, f2]);
[y_high_pass, filter_high] = myFilter(y, Fs, N, 'Hamming', 'high-pass', f2);

%% Plot filter spectrum
subplot(1, 3, 1);
plot_spectrum(filter_low, Fs, 'Low-pass filter');

subplot(1, 3, 2);
plot_spectrum(filter_band, Fs, 'Bandpass filter');

subplot(1, 3, 3);
plot_spectrum(filter_high, Fs, 'High-pass filter');

%% Plot filter shape
figure;
subplot(1, 3, 1);
plot(filter_low);
title('Low-pass');

subplot(1, 3, 2);
plot(filter_band);
title('Bandpass');

subplot(1, 3, 3);
plot(filter_high);
title('High-pass');

%% Plot filtered result spectrum vs. original
figure;
subplot(1, 4, 1);
plot_spectrum(y, Fs, 'Original');

subplot(1, 4, 2);
plot_spectrum(y_low_pass, Fs, 'Low-pass result');

subplot(1, 4, 3);
plot_spectrum(y_band_pass, Fs, 'Bandpass result');

subplot(1, 4, 4);
plot_spectrum(y_high_pass, Fs, 'High-pass result');

%% Save the filtered audio (wavwrite or audiowrite)
audiowrite('low_pass.wav', y_low_pass, Fs);
audiowrite('band_pass.wav', y_band_pass, Fs);
audiowrite('high_pass.wav', y_high_pass, Fs);