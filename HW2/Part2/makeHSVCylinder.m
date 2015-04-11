% Problem 2b

clear all; close all; clc;

%% Define Vertices
numOfVert = 689;
vertPolarAngle = linspace(0, 2*pi, numOfVert+1);
topVertIndex = 1:numOfVert;
botVertIndex = numOfVert+1:2*numOfVert;
topVerts = [];
botVerts = [];

for i = 1:numOfVert
	vertX = cos(vertPolarAngle(i));
	vertY = sin(vertPolarAngle(i));
	topVerts = [ topVerts; vertX vertY 1];
	botVerts = [ botVerts; vertX vertY 0];
end
verts = [ topVerts; botVerts ];

verts = [ verts; 0 0 1 ];
[topCenterIndex, ~] = size(verts);
verts = [ verts; 0 0 0 ];
[botCenterIndex, ~] = size(verts);

%% Define Colors (Your efforts here)
vertColors = [];
for i = 0:numOfVert-1
	vertColors = [ vertColors; hsv2rgb([i/numOfVert 1 1])];
end
for i = 0:numOfVert-1
	vertColors = [ vertColors; hsv2rgb([i/numOfVert 1 0])];
end
vertColors = [ vertColors; hsv2rgb([0 0 1]); hsv2rgb([0 0 0]) ];
%% Faces
faces = [];
for i = 1:numOfVert
	j = mod(i, numOfVert)+1;
	% Top faces
	faces = [ faces; topCenterIndex i j ];
	% Bottom faces
	faces = [ faces; botCenterIndex numOfVert+j numOfVert+i ];
	% Side face
	faces = [ faces; numOfVert+i j i ];
	faces = [ faces; j numOfVert+i numOfVert+j ];

end

%% Write to .obj File
writeColorObj( 'HSVCylinder.obj', verts, vertColors, faces );