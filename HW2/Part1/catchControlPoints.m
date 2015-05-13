clear all; close all; clc;
darkFigure();
catImage = im2double(imread('github_icon.png'));
[h, w, ~] = size(catImage);
imshow(catImage);

%% Mouse input
xlabel ('Select at most 200 points along the outline', 'FontName', '微軟正黑體', 'FontSize', 14);
[ ctrlPointX, ctrlPointY ] = ginput(200);
ctrlPointList = [ctrlPointX ctrlPointY];
clickedN = size(ctrlPointList,1);

promptStr = sprintf('%d points selected', clickedN);
xlabel (promptStr, 'FontName', '微軟正黑體', 'FontSize', 14);

%% Calculate Bㄚˇzier curve (Your efforts here)
outlineVertexList = ctrlPointList; 


%% Draw and fill the polygon
drawAndFillPolygon( catImage, ctrlPointList, outlineVertexList, true, true, true ); %ctrlPointScattered, polygonPlotted, filled

%% Save my precious ctrlPointList

% delete some points if it's not 3n+1
[sz, ~] = size(ctrlPointList);
d = mod(sz-1+3, 3);
for i = 1:d
	ctrlPointList(randi(sz-d), :) = [];
end
save('ctrlPoints.mat', 'ctrlPointList')