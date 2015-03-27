%% clear, close all shit
clear all; close all; clc;

%% get the images
bffilter_img = im2double(imread('../data/BayerFilter.bmp'));
cat_img = im2double(imread('../data/Catvengers.png'));
bfcat_img = im2double(imread('../data/BFCatvengers.png'));
result_img = bfcat_img;

%% get property of the image
[w, h, ~] = size(cat_img);

%% nearest neighbor algorithm
for i = 2:w-1
	for j = 2:h-1
		for k = 1:3
			% we only care about the missing color
			if bffilter_img(i, j, k) == 0
				% get resonable range
				i1 = i-1; i2 = i+1;
				j1 = j-1; j2 = j+1;
				ori = bfcat_img(i1:i2, j1:j2, k); % filtered image
				fil = bffilter_img(i1:i2, j1:j2, k); % filter
				s =  ori .* fil;
				avg_color = sum(s(:)) / sum(fil(:));
				result_img(i, j, k) = avg_color;
			end
		end
	end
end

%% compute PSNR
% square mean difference of 2 images
MSE_mat = (cat_img - result_img) .^ 2;
% sum all elements in MSE_mat
MSE = sum(MSE_mat(:)) / (3*w*h);
MAXi = 1;
PSNR = 10 * log10(MAXi^2 / MSE);

fprintf('The Peak-SNR value is %0.4f\n', PSNR);

%% plot the result
% make it full screen
figure('units','normalized','outerposition',[0 0 1 1])

% split 3 parts
subplot(1, 3, 1);
imshow(bfcat_img);
title('BFCatvengers.png');

subplot(1, 3, 2);
imshow(cat_img);
title('Catvengers.png');

subplot(1, 3, 3);
imshow(result_img);
title('My Result');

%% save the result
imwrite(result_img, '../result/P1/result.png');
