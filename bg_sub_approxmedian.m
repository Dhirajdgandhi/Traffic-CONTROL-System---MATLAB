xyloObj = VideoReader('4_edge_Sobel.avi');

writerObj1 = VideoWriter('4_Sobel_bg_sub_median');
writerObj2 = VideoWriter('4_Sobel_bg_median');
open(writerObj2);
open(writerObj1);

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

considerFrames=nFrames;
n=10;

bg=double(zeros(vidHeight,vidWidth));
bgrnd_img=double(zeros(vidHeight,vidWidth));

for k = 1 : considerFrames
    frame = read(xyloObj, k); 
    frame=double(rgb2gray(frame));
    k=k
    if(k>n)
       for i = 1 : vidHeight
           for j = 1 : vidWidth
               if( frame(i,j)> bg(i,j) )
                    bg(i,j)=bg(i,j)+1;
               else
                    bg(i,j)=bg(i,j)-1;
               end 
           end
       end
       bg=double(bg);
       im_sub=uint8(frame - bg);
    else
       bgrnd_img=bgrnd_img+(frame);
       bg= bgrnd_img/k;
       im_sub=uint8(bg);
    end
    
    %im_sub=uint8(imbinarize(im_sub,0.10)*255);  %BEST TILL NOW
    writeVideo(writerObj2, uint8(bg));
    writeVideo(writerObj1, im_sub);
end

%bgrnd_img=uint8(bgrnd_img);
close(writerObj1);
close(writerObj2);