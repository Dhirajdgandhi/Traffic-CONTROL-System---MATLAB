xyloObj = VideoReader('4_thresholded.avi');

writerObj1 = VideoWriter('4_morpho');
open(writerObj1);
writerObj2 = VideoWriter('4_morpho_conv');
open(writerObj2);
writerObj3 = VideoWriter('4_morpho_erode');
open(writerObj3);


nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

considerFrames=nFrames;
n=20;

SE_dilate = strel('square', 31);
SE_erode = strel('disk', 41);
    
for k = 1 : considerFrames
    frame = read(xyloObj, k); 
    frame=(rgb2gray(frame));
  
    k=k
    
    im_conv=uint8( bwconvhull(frame,'objects')*255)  ;
    writeVideo(writerObj2, uint8(im_conv));
    
    im_erode=uint8(imerode(im_conv,SE_erode));
    writeVideo(writerObj3, uint8(im_erode));
    
    im_dilate=uint8(imdilate(im_erode,SE_dilate));
    
    writeVideo(writerObj1, uint8(im_dilate));
end

close(writerObj1);
close(writerObj2);
close(writerObj3);
