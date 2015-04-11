clear all; close all; clc;
darkFigure();
catImage = im2double(imread('github_icon.png'));
[h, w, ~] = size(catImage);
imshow(catImage);
load('ctrlPoints.mat');

%% Mouse input
% xlabel ('Select at most 200 points along the outline', 'FontName', '微軟正黑體', 'FontSize', 14);
% [ ctrlPointX, ctrlPointY ] = ginput(200);
% ctrlPointList = [ctrlPointX ctrlPointY];
% clickedN = size(ctrlPointList,1);
% 
% promptStr = sprintf('%d points selected', clickedN);
% xlabel (promptStr, 'FontName', '微軟正黑體', 'FontSize', 14);

%% Calculate Bㄚˇzier curve (Your efforts here)
t = linspace(0,1, 20)';
bez = @(t,P) ...
  bsxfun(@times,(1-t).^3,P(1,:)) + ...
  bsxfun(@times,3*(1-t).^2.*t,P(2,:)) + ...
  bsxfun(@times,3*(1-t).^1.*t.^2,P(3,:)) + ...
  bsxfun(@times,t.^3,P(4,:));

[sz, ~] = size(ctrlPointList);
outlineVertexList = []; 

%Enrich outlineVertexList
for i = 1:3:sz-3
	outlineVertexList = [ outlineVertexList; bez(t, ctrlPointList(i:i+4, :)) ];
end

%% Draw and fill the polygon
drawAndFillPolygon( catImage, ctrlPointList, outlineVertexList, true, true, true ); %ctrlPointScattered, polygonPlotted, filled

%% Save my precious ctrlPointList
% save('ctrlPoints.mat', 'ctrlPointList')