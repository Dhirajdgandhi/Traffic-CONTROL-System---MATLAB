xyloObj = VideoReader('4_rgb2gray.avi');

writerObj1 = VideoWriter('4_bg_sub_running_mean');
writerObj2 = VideoWriter('4_bg_running_mean');

open(writerObj1);
open(writerObj2);

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

considerFrames=nFrames;
n=20;

bgrnd_img=double(zeros(vidHeight,vidWidth));

%mov(1:considerFrames) = struct('cdata', zeros(vidHeight, vidWidth,3, 'uint8'), 'colormap', []);

for k = 1 : considerFrames
    frame = read(xyloObj, k); 
    frame=double(rgb2gray(frame));
    k=k
    %bgrnd_img=bgrnd_img+(im1);
    
    if(k>n)
        im_n = read(xyloObj, k-n);
        im_n=double(im_n);
        bgrnd_img=bgrnd_img+frame-im_n;
        mean_bg= bgrnd_img/n;
    else
        bgrnd_img=bgrnd_img+(frame);
        mean_bg= bgrnd_img/k;
    end
    
    im_sub=uint8(frame - mean_bg);
    
    %     % Generate horizontal edge using sobel filter
    %     h = fspecial('sobel');
    %     % Apply filter to get horizontal edges
    %     im_sub = uint8(imfilter(im_sub,h) + imfilter(im_sub,h'));
    %     
    writeVideo(writerObj2,uint8(mean_bg) );
    writeVideo(writerObj1, im_sub);
end 

close(writerObj1);
close(writerObj2);
