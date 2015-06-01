function hw4(part)
%% Initial data
Tn = [8, 17];
R = f(7);
T1 = f(Tn(1));
T2 = f(Tn(2));
T = cat(3,T1, T2);
%% part (a)
if part == 'a'
	for nn = 1:2
		for dd= 1:2
			for i = 1:2
				N = nn*8;  % block size
				d = dd*8;  % search range
				residual_img = full_search(N, d, T(:,:,i), R);
				imwrite(residual_img, sprintf('output/Full_N=%d_d=%d_frame=%02d.png', N, d, Tn(i)));
				fprintf('Full N=%2d d=%2d frame=%02d Total_SAD=%.3f\n', N, d, Tn(i), sum(residual_img(:)));
				residual_img = two_D(N, d, T(:,:,i), R);
				fprintf('2Dlg N=%2d d=%2d frame=%02d Total_SAD=%.3f\n', N, d, Tn(i), sum(residual_img(:)));
				imwrite(residual_img, sprintf('output/2Dlg_N=%d_d=%d_frame=%02d.png', N, d, Tn(i)));
			end
		end
	end
end
%% part (b)
if part == 'b'
	for nn = 1:2
		for dd= 1:2
			full_psnr = [];
			twoD_psnr = [];
			N = nn*8;  % block size
			d = dd*8;  % search range
			for i =8:17
				T = f(i);	
				residual_img = full_search(N, d, T, R);
				full_psnr = [full_psnr psnr(residual_img, residual_img*0)];
				residual_img = two_D(N, d, T, R);
				twoD_psnr = [twoD_psnr psnr(residual_img, residual_img*0)];
			end
			h = figure;
			plot(8:17, full_psnr, 8:17, twoD_psnr);
			legend('full search', '2D logarithm');
			name = sprintf('N=%d d=%d', N, d);
			title(name);
			saveas(h, strcat('output/', name), 'png');
		end
	end
end
%% part (c)
T = f(17);
if part == 'c'
	for nn = 1:2
		for dd= 1:2
			N = nn*8;  % block size
			d = dd*8;  % search range
			tic;
			residual_img = full_search(N, d, T, R);
			t = toc;
			fprintf('Full Search  N=%2d d=%2d time=%.3f ', N, d, t);
			fprintf('Total_SAD=%.3f\n', sum(residual_img(:)));
			tic;
			residual_img = two_D(N, d, T, R);
			t = toc;
			fprintf('2D logarithm N=%2d d=%2d time=%.3f ', N, d, t);
			fprintf('Total_SAD=%.3f\n', sum(residual_img(:)));
		end
	end	
end
end

%% get n-th frame
function img = f(n)
	fname = sprintf('input/caltrain%03d.bmp', n);
	img = im2double(rgb2gray(imread(fname)));
end

%% SAD
function SAD_val = SAD(T, R)
	SAD_val = sum(abs(T(:) - R(:)));
end

%% Full-search
function residual_img = full_search(N, d, T, R)
	residual_img = R;
	[h, w] = size(T);
	for x = 1:N:h-1
		for y = 1:N:w-1
			block_SAD = 1e9;
			mb_T = T(x:x+N-1, y:y+N-1);
			for i = -d:d
				for j = -d:d
					if x+i+N-1 > h || x+i < 1 || y+j+N-1 > w || y+j < 1
						continue
					end
					mb_R = R(x+i:x+i+N-1, y+j:y+j+N-1);
					tmp_SAD = SAD(mb_T, mb_R);
					if tmp_SAD < block_SAD
						block_SAD = tmp_SAD;
						residual_img(x:x+N-1, y:y+N-1) = abs(mb_T - mb_R);
					end
				end
			end
		end
	end
end

%% 2D logarithm
function residual_img = two_D(N, d, T, R)
	residual_img = R;
	[h, w] = size(T);
	n_ = floor(log2(d));
	n = max(2, 2^(n_-1));
	M = [0 0; 1 0; 0 1; 0 -1; -1 0];
	for x = 1:N:h-1
		for y = 1:N:w-1
			mb_T = T(x:x+N-1, y:y+N-1);
			dx = 0; dy = 0;
			nn = n;
			M_ = M * nn;
			while nn > 1
				[len, ~] = size(M_);
				block_SAD = 1e9;
				di = 1;
				for i = 1:len
					pos = [x+dx, y+dy] + M_(i,:);
					xx = pos(1); yy = pos(2);
					if xx < 1 || xx+N-1 > h || yy < 1 || yy+N-1 > w
						continue
					end
					mb_R = R(xx:xx+N-1, yy:yy+N-1);
					tmp_SAD = SAD(mb_T, mb_R);
					if tmp_SAD < block_SAD
						block_SAD = tmp_SAD;
						di = i;
					end
				end
				if di ~= 1
					dx = dx + M_(di, 1);
					dy = dy + M_(di, 2);
					M_(di,:) = [];
				else
					nn = floor(nn / 2);
					M_ = M * nn;
				end
			end
			M_ = [0 0; 1 0; 0 1; 0 -1; -1 0; 1 1; -1 -1; 1 -1; -1 1];
			mb_R = mb_T;
			for i = 1:9
				pos = [x+dx, y+dy] + M_(i,:);
				xx = pos(1); yy = pos(2);
				if xx < 1 || xx+N-1 > h || yy < 1 || yy+N-1 > w
					continue
				end
				mb_RR = R(xx:xx+N-1, yy:yy+N-1);
				tmp_SAD = SAD(mb_T, mb_RR);
				if tmp_SAD < block_SAD
					block_SAD = tmp_SAD;
					mb_R = mb_RR;
				end
			end
			residual_img(x:x+N-1, y:y+N-1) = abs(mb_T - mb_R);
		end
	end
end