function [out, filter] = myFilter(in, fs, N, wFun, type, para)

% in: input signal
% fs: sampling frequency
% N : size of FIR filter, assumed to be odd
% wFun: 'Hanning', 'Hamming', 'Blackman'
% type: 'low-pass', 'high-pass', 'bandpass' 
% para: cut-off frequency or band frequencies corresponding to the filter type
%       if type is 'low-pass' or 'high-pass', para has only one element         
%       if type is 'bandpass' or 'bandstop', para is a vector of 2 elements

%% 1. Normalization
fc = para / fs;
middle = floor(N/2);

%% 2. Create the filter according the ideal equations in Table5.2
filter = zeros(1, N);
if strcmp(type,'low-pass')==1
	for n = -middle:middle
		ind = n + middle + 1;
		if n == 0
			filter(ind) = 2 * fc;
		else
			filter(ind) = sin(2 * pi * fc * n) / (pi * n);
		end
	end
elseif strcmp(type,'high-pass')==1
	for n = -middle:middle
		ind = n + middle + 1;
		if n == 0
			filter(ind) = 1 - 2 * fc;
		else
			filter(ind) = -sin(2 * pi * fc * n) / (pi * n);
		end
	end
elseif strcmp(type,'bandpass')==1
	for n = -middle:middle
		ind = n + middle + 1;
		if n == 0
			filter(ind) = 2 * (fc(2) - fc(1));
		else
			filter(ind) =  sin(2 * pi * fc(2) * n) / (pi * n) -   sin(2 * pi * fc(1) * n) / (pi * n);
		end
	end
end

%% 3. Create the windowing function
%% 4. Get the realistic filter
if strcmp(wFun,'Hanning')==1
	for n = 1:N
		filter(n) = filter(n) * (0.5 - 0.5*cos((2*pi*n)/N));
	end
elseif strcmp(wFun,'Hamming')==1
	for n = 1:N
		filter(n) = filter(n) * (0.54 - 0.46*cos((2*pi*n)/N));
	end

elseif strcmp(wFun,'Blackman')==1
	for n = 1:N
		filter(n) = filter(n) * (0.42 - 0.5*cos((2*pi*n)/(N-1)) + 0.08*cos((4*pi*n)/(N-1)));
	end
end

% 5. Filter the input signal in time domain. Do not use matlab function 'conv'
[L, ~] = size(in);
out = zeros(1, L);
for n = 1:L
	for k = 1:N
		if n - k < 1
			ininder = 0;
		else
			ininder = in(n - k);
		end
		out(n) = out(n) + filter(k) * ininder;
	end
end