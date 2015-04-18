clear all; close all; clc;
darkFigure();
catImage = im2double(imread('github_icon.png'));
[h, w, ~] = size(catImage);
%imshow(catImage);
load('ctrlPoints.mat');

%% Calculate B£«£¾zier curve (Your efforts here)
t = linspace(0,1, 100)';
bez = @(t,P) ...
  bsxfun(@times,(1-t).^3,P(1,:)) + ...
  bsxfun(@times,3*(1-t).^2.*t,P(2,:)) + ...
  bsxfun(@times,3*(1-t).^1.*t.^2,P(3,:)) + ...
  bsxfun(@times,t.^3,P(4,:));

[sz, ~] = size(ctrlPointList);
outlineVertexList = []; 

%Enrich outlineVertexList
for i = 1:3:sz-4
	outlineVertexList = [ outlineVertexList; bez(t, ctrlPointList(i:i+4, :)) ];
end
outlineVertexList = [ outlineVertexList; bez(t, ctrlPointList([77 78 79 1], :)) ];

%% Draw and fill the polygon
drawAndFillPolygon( catImage, outlineVertexList, outlineVertexList, false, true, true ); %ctrlPointScattered, polygonPlotted, filled
figure
plot(outlineVertexList(:,1), outlineVertexList(:,2));