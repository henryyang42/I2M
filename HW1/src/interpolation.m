%% clear, close all shit
clear all; close all; clc;

%% get the images
cat_img = im2double(imread('../data/Catvengers_gray.png'));

%% get property of the image
[w, h] = size(cat_img);

%% assign 4X size
nni_img = zeros(w*4, h*4, 3);
bi_img = zeros(w*4, h*4, 3);

%% nearest-neighbor (NN) interpolation
for i = 1:4*w
	for j = 1:4*h
		% make sure ii, jj in range [1, size]
		ii = min(w, round((i-1)/4)+1);
		jj = min(h, round((j-1)/4)+1);
		nni_img(i, j, :) = cat_img(ii, jj, :);
	end
end
%% bilinear interpolation
% we neglect the border here
for i = 4:4*w-4
	for j = 4:4*h-4
		a = i/4; b = j/4;
		x = floor(a); y = floor(b);
		A = a-x;
		B = b-y;
		% assigning weights
		bi_img(i, j, :) = ...
			(cat_img(x, y, :)*(1-A)*(1-B) ...
			+ cat_img(x+1, y, :)*(A)*(1-B) ... 
			+ cat_img(x, y+1, :)*(1-A)*(B) ...
			+ cat_img(x+1, y+1, :)*(A)*(B));
	end
end

%% plot the result
imshow(cat_img);
title('Original');
figure

imshow(nni_img);
title('Nearest-neighbor (NN) interpolation');

figure
imshow(bi_img);
title('Bilinear interpolation');

