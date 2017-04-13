medianObj = VideoReader('4_gray_bg_sub_median.avi');
edgeObj = VideoReader('4_sobel_bg_sub_median.avi');

writerObj1 = VideoWriter('4_median_plus_sobeledge');
open(writerObj1);

nFrames = medianObj.NumberOfFrames;
vidHeight = medianObj.Height;
vidWidth = medianObj.Width;

considerFrames=nFrames;
n=20;

for k = 1 : considerFrames
    medianframe = read(medianObj, k); 
    medianframe=double(rgb2gray(medianframe));
  
    edgeframe = read(edgeObj, k); 
    edgeframe=double(rgb2gray(edgeframe));
  
    im_new=uint8((medianframe+edgeframe)/2);
    k=k
    %im_sub=uint8( bwconvhull(im_sub,'objects')*255)  ;
    writeVideo(writerObj1, im_new);
end

close(writerObj1);
