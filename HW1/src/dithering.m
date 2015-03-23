%% clear, close all shit
clear all; close all; clc;

%% get the images
lena_img = im2double(imread('../data/lena_gray.bmp'));
thresholding_img = lena_img;
error_diffusion_img1 = lena_img;
error_diffusion_img2 = lena_img;

%% get property of the image
[w, h] = size(lena_img);

%% thresholding
% set threshhold value the average of the gray scale
threshhold_val = sum(sum(lena_img)) / (w*h);
for i = 1:w
	for j = 1:h
		if lena_img(i, j) < threshhold_val
			thresholding_img(i, j) = 0;
		else
			thresholding_img(i, j) = 1;
		end
	end
end

%% error diffusion dithering with two masks
% mask #1
mask1 = [0 0 7; 3 5 1];
for i = 1:w
	for j = 1:h
		p = error_diffusion_img1(i, j);
		if p < 0.5
			e = p;
			error_diffusion_img1(i, j) = 0;
		else
			e = p-1;
			error_diffusion_img1(i, j) = 1;
		end
		% change the value of neighbor pixel
		for di = 0:1
			for dj = -1:1
				if i+di >= 1 && i+di <=w && j+dj >= 1 && j+dj <=h
					error_diffusion_img1(i+di, j+dj) = ...
						error_diffusion_img1(i+di, j+dj) + ...
						e*mask1(1+di, 2+dj)/16;
				end
			end
		end
	end
end

% mask #2
mask2 = [0 0 0 7 5; 3 5 7 5 3; 1 3 5 3 1];
for i = 1:w
	for j = 1:h
		p = error_diffusion_img2(i, j);
		if p < 0.5
			e = p;
			error_diffusion_img2(i, j) = 0;
		else
			e = p-1;
			error_diffusion_img2(i, j) = 1;
		end
		% change the value of neighbor pixel
		for di = 0:2
			for dj = -2:2
				if i+di >= 1 && i+di <=w && j+dj >= 1 && j+dj <=h
					error_diffusion_img2(i+di, j+dj) = ...
						error_diffusion_img2(i+di, j+dj) + ...
						e*mask2(1+di, 3+dj)/48;
				end
			end
		end
	end
end

%% plot the result
% make it full screen
figure('units','normalized','outerposition',[0 0 1 1])

% split 3 parts
subplot(1, 3, 1);
imshow(thresholding_img);
title('Thresholding');

subplot(1, 3, 2);
imshow(error_diffusion_img1);
title('Error diffusion with mask #1');

subplot(1, 3, 3);
imshow(error_diffusion_img2);
title('Error diffusion with mask #2');