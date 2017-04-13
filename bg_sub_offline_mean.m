xyloObj = VideoReader('4_rgb2gray.avi');

writerObj1 = VideoWriter('4_bg_sub_offline_mean');
open(writerObj1);

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

considerFrames=300;
n=20;

bgrnd_img=double(zeros(vidHeight,vidWidth));

%mov(1:considerFrames) = struct('cdata', zeros(vidHeight, vidWidth,3, 'uint8'), 'colormap', []);

for k = 1 : considerFrames
    frame = read(xyloObj, k); 
    frame=double(rgb2gray(frame));
    
    bgrnd_img=bgrnd_img+(frame);
end

mean_bg=bgrnd_img/considerFrames;

for k = 1 : considerFrames
    frame = read(xyloObj, k); 
    frame=double(rgb2gray(frame));
   
    im_sub=uint8(frame - mean_bg);
    writeVideo(writerObj1, im_sub);
end

mean_bg=uint8(mean_bg);
imshow(mean_bg);
close(writerObj1);