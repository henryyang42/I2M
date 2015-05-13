clear all; close all; clc;
darkFigure();
catImage = im2double(imread('github_icon.png'));
[h, w, ~] = size(catImage);

load('ctrlPoints.mat');
%% Calculate B£«£¾zier curve (Your efforts here)
t = linspace(0,1, 50)';

% Anonymous Function for blending
blending_func = @(t,P) ...
  bsxfun(@times,(1-t).^3,P(1,:)) + ...
  bsxfun(@times,3*(1-t).^2.*t,P(2,:)) + ...
  bsxfun(@times,3*(1-t).^1.*t.^2,P(3,:)) + ...
  bsxfun(@times,t.^3,P(4,:));

[sz, ~] = size(ctrlPointList);
outlineVertexList = []; 

%Enrich outlineVertexList
for i = 1:3:sz-1
	outlineVertexList = [ outlineVertexList; blending_func(t, ctrlPointList(i:i+3, :)) ];
end

%% Draw and fill the polygon
drawAndFillPolygon( catImage, ctrlPointList, outlineVertexList, true, true, true );

catImage4 = imresize(catImage, 4, 'nearest');
figure;
drawAndFillPolygon( catImage4, ctrlPointList*4, outlineVertexList*4, true, true, true );
