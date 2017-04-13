Obj = VideoReader('4_morpho.avi');
Obj1 = VideoReader('traffic_4.mp4');
writerObj1 = VideoWriter('4_connected');
writerObj2 = VideoWriter('4_connected_plus_orig');
writerObj2.FrameRate=25;

open(writerObj1);
open(writerObj2);

nFrames = Obj.NumberOfFrames;
vidHeight = Obj.Height;
vidWidth = Obj.Width;

clr=[0 250 0];

considerFrames=nFrames;
n=20;
% New - Create structuring element
se = strel('square', 3);

disp("Traffic count after every 2 seconds");
for k = 1 : considerFrames
  %  centroid=double(zeros(vidHeight,vidWidth));

    frame = read(Obj, k);
    frame_orig = read(Obj1, k);
    frame=(im2bw(frame));
    
    frame_orig=(imresize(rgb2gray(frame_orig),[360 480]));
    frame_orig=(imresize(frame_orig,[360 480]));
    
    k=k;
    CC = bwconncomp(frame,8);
    num=CC.NumObjects;

    S = regionprops(CC,'Centroid','Area');
 
    %Every 2 seconds
    if(mod(k,30)==0)
        disp((k/30)+"secs : "+num)
    end
  
    % Perimeter of connectetd components
    im_new = bwperim(frame,8)*255;
    im_new=cat(3,im_new,frame*0,frame*0);
    frame_orig=cat(3,frame_orig,frame_orig,frame_orig);
    
    im_sum=frame_orig+uint8(im_new);
    
    writeVideo(writerObj1, uint8(im_new));
    writeVideo(writerObj2, uint8(im_sum));
 
end

close(writerObj1);
close(writerObj2);