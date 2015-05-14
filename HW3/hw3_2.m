clear all;close all;clc;

[y, Fs] = audioread('AnJing_4bit.wav');
[n, ch] = size(y);
%% Plot the spectrum and shape
subplot(1,2,1);
plot_spectrum(y, Fs, 'Original spectrum');
subplot(1,2,2);
plot(y(:,1)); % Only plot one of its channel
title('Original shape');

%% Add random noise
F_in = y ;
for i = 1:n
	for j = 1:ch
		F_in(i, j) = F_in(i, j) +  (rand - 0.5);
	end
end

%% First-order feedback loop for noise shaping
F_out = y;
c = 0.8;
for i = 1:n
	for j = 1:ch
		if i == 1
			Ei = 0;
		else
			Ei = F_in(i-1, j) - F_out(i-1, j);
		end
		F_out(i, j) = F_in(i, j) + c * Ei;
	end
end

[F_out(:,1), ~] = myFilter(F_out(:,1) , Fs, 1001, 'Hamming', 'low-pass', 500);
[F_out(:,2), ~] = myFilter(F_out(:,2) , Fs, 1001, 'Hamming', 'low-pass', 500);

size(F_out)
audiowrite('qaq.wav', F_out, Fs);
