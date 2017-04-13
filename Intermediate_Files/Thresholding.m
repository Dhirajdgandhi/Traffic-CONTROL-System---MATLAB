xyloObj = VideoReader('4_gray_bg_sub_median.avi');

writerObj1 = VideoWriter('4_thresholded_without_addition');
open(writerObj1);

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

considerFrames=nFrames;
n=20;

for k = 1 : considerFrames
    frame = read(xyloObj, k); 
    frame=uint8(rgb2gray(frame));
  
    k=k
    im_bw=uint8(imbinarize(frame,0.1)*255);  %BEST TILL NOW
    
    writeVideo(writerObj1, im_bw);
end

close(writerObj1);    
