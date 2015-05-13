function hw3
	% hw3.m - 請完整寫出把三首歌都分出來的過程
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

	%% Plot the filtered result
	
	fvtool(filter_low);
fvtool(filter_band);
fvtool(filter_high);

	
	subplot(1, 3, 1);
	plot_sound(y_low_pass, Fs, 'Low-pass result');
	
	subplot(1, 3, 2);
	plot_sound(y_band_pass, Fs, 'Bandpass result');
	
	subplot(1, 3, 3);
	plot_sound(y_high_pass, Fs, 'High-pass result');
	
	% Save the filtered audio (wavwrite or audiowrite)
	audiowrite('low_pass.wav', y_low_pass, Fs);
	audiowrite('band_pass.wav', y_band_pass, Fs);
	audiowrite('high_pass.wav', y_high_pass, Fs);
	
end
%% Some utilities

function plot_sound(y, Fs, title_text)
	% Frequency analysis
	% y1: signal, Fs1: sampling rate
    y1 = y;
    Fs1 = Fs;
    L = 2^nextpow2(max(size(y1)));
    y1_FFT = fft(y1,L);
    xx = Fs1/2*linspace(0,1,L/2+1);
    plot(xx,abs(y1_FFT(1:L/2+1)));
	title(title_text);
end
