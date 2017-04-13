xyloObj = VideoReader('4_rgb2gray.avi');

writerObj1 = VideoWriter('4_edge_Canny');
open(writerObj1);

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

considerFrames=nFrames;
n=20;

h=fspecial('Sobel');

for k = 1 : considerFrames
    frame = read(xyloObj, k); 
    frame=double(rgb2gray(frame));
    k=k
    % Using Sobel operator
    %im_edge=uint8(imfilter(frame,h)+imfilter(frame,h'));
    
    % Using Canny edge detection
    im_edge=uint8(edge(frame,'Canny')*255);
    writeVideo(writerObj1, im_edge);
end

close(writerObj1);    