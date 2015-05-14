clear all;close all;clc;

[y, Fs] = audioread('AnJing_4bit.wav');
[n, ch] = size(y);
y = y * 128;
%% Plot the spectrum and shape
subplot(2,4,1);
plot_spectrum(y, Fs, 'Original spectrum');
subplot(2,4,2);
plot(y(50000:60000,1)); % Only plot part of one of its channel
title('Original shape');

%% Add random noise
F_in = y;
for i = 1:n
	for j = 1:ch
		F_in(i, j) = F_in(i, j) +  (rand - 0.5)*16;
	end
end
subplot(2,4,3);
plot_spectrum(F_in, Fs, 'Noised spectrum');
subplot(2,4,4);
plot(F_in(50000:60000,1)); % Only plot part of one of its channel
title('Noised shape');

%% First-order feedback loop for noise shaping
F_out = F_in;
c = 0.9;
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
subplot(2,4,5);
plot_spectrum(F_out, Fs, 'Shapped spectrum');
subplot(2,4,6);
plot(F_out(50000:60000,1)); % Only plot part of one of its channel
title('Shapped shape');

[F_out(:,1), ~] = myFilter(F_out(:,1) , Fs, 1001, 'Hamming', 'low-pass', 500);
[F_out(:,2), ~] = myFilter(F_out(:,2) , Fs, 1001, 'Hamming', 'low-pass', 500);
subplot(2,4,7);
plot_spectrum(F_out, Fs, 'Low-passed spectrum');
subplot(2,4,8);
plot(F_out(50000:60000,1)); % Only plot part of one of its channel
title('Low-passed shape');

audiowrite('AnJing_4bit_shaped.wav', F_out/128, Fs);
