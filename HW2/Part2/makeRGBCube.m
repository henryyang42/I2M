% Problem 2a

clear all; close all; clc;

%% Define Vertices
topVerts = [ 0 1 0; 0 1 1; 1 1 1; 1 1 0];
topVertIndex = [ 1 2 3 4 ];
botVerts = [ 0 0 0; 0 0 1; 1 0 1; 1 0 0];
botVertIndex = [ 5 6 7 8 ];

verts = [ topVerts; botVerts ];

%% Define Colors (Your efforts here)
vertColors = [topVerts; botVerts];

%% Empty faces list
faces = [];

%% Top faces
faces = [ faces ; 1 2 3 ; 1 3 4 ];

%% Side faces (Your efforts here)
for vertI = 1 : 4
	faceVert1 = topVertIndex( mod(vertI,4)+1 );
	faceVert2 = topVertIndex( vertI );
	faceVert3 = botVertIndex( mod(vertI,4)+1 );
	faceVert4 = botVertIndex( vertI );

	faces = [ faces ; 
		faceVert1 faceVert2 faceVert3; 
		faceVert4 faceVert3 faceVert2 ];
end

%% Bottom faces
faces = [ faces ; 5 7 6 ; 5 8 7 ];

%% Write to .obj File
writeColorObj( 'RGBCube.obj', verts, vertColors, faces );