function writeColorObj( filename, vertCoordList, vertRGBList, faceList )

fileID = fopen(filename,'w');

% Print vertices
fprintf(fileID,'v %f %f %f %f %f %f\n',[vertCoordList,vertRGBList]' );

% Print faces
faceList = int32(faceList);
fprintf(fileID,'f %d %d %d\n',faceList' );

fclose(fileID);
end

