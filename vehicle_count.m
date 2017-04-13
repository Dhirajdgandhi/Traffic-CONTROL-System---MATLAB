%%%%%%%%% RGB 2 GRAY %%%%%%%%
xyloObj = VideoReader('traffic_4.mp4');
writerObj = VideoWriter('4_rgb2gray');
writerObj.FrameRate=30;

open(writerObj);
row=360;
col=480;

nFrames = xyloObj.NumberOfFrames;
considerFrames=200;

for k = 1 : considerFrames
    k=k
    frame = read(xyloObj, k);
    frame=(rgb2gray(frame));
    frame=imresize(frame,[row col]);
    writeVideo(writerObj, frame);
end

close(writerObj);


%%%%%%%%% END OF RGB 2 GRAY %%%%%%%%

%%%%%%%%% EDGE DETECTION - SOBEL /  CANNY %%%%%%%%
xyloObj = VideoReader('4_rgb2gray.avi');
writerObj1 = VideoWriter('4_edge_Sobel');
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
    im_edge=uint8(imfilter(frame,h)+imfilter(frame,h'));
    
    % Using Canny edge detection
    %im_edge=uint8(edge(frame,'Canny')*255);
    writeVideo(writerObj1, im_edge);
end

close(writerObj1);    
%%%%%%%%% END EDGE DETECTION - SOBEL /  CANNY %%%%%%%%




%%%%%%%%% BACKGROUND SUBTRACTION OF EDGE VIDEO %%%%%%%%
xyloObj = VideoReader('4_edge_Sobel.avi');

writerObj1 = VideoWriter('4_sobel_bg_sub_median');
writerObj2 = VideoWriter('4_sobel_bg_median');
open(writerObj2);
open(writerObj1);

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
%%%%%%%%% END BACKGROUND SUBTRACTION OF EDGE VIDEO %%%%%%%%





%%%%%%%%% BACKGROUND SUBTRACTION OF GRAY VIDEO %%%%%%%%
xyloObj = VideoReader('4_rgb2gray.avi');

writerObj1 = VideoWriter('4_gray_bg_sub_median');
writerObj2 = VideoWriter('4_gray_bg_median');
open(writerObj2);
open(writerObj1);

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

%%%%%%%%% END OF BACKGROUND SUBTRACTION OF GRAY VIDEO %%%%%%%%



%%%%%%%%% ADDITION STEP - ADDING OUTPUT OF PREVIOUS 2 OUTPUTS %%%%%%%%

medianObj = VideoReader('4_gray_bg_sub_median.avi');
edgeObj = VideoReader('4_sobel_bg_sub_median.avi');

writerObj1 = VideoWriter('4_median_plus_sobeledge');
open(writerObj1);

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

%%%%%%%%% END ADDITION STEP %%%%%%%%




%%%%%%%%% THRESHOLDING TO GET THE OBJECTS OF INTEREST %%%%%%%%

xyloObj = VideoReader('4_median_plus_sobeledge.avi');

writerObj1 = VideoWriter('4_thresholded');
open(writerObj1);

n=20;

for k = 1 : considerFrames
    frame = read(xyloObj, k); 
    frame=uint8(rgb2gray(frame));
  
    k=k
    im_bw=uint8(imbinarize(frame,0.1)*255);  %BEST TILL NOW
    
    writeVideo(writerObj1, im_bw);
end

close(writerObj1);    

%%%%%%%%% END OF THRESHOLDING %%%%%%%%





%%%%%%%%% MORPHOLOGY - CONVOLUTION/EROSION/DILATION  %%%%%%%%

xyloObj = VideoReader('4_thresholded.avi');

writerObj1 = VideoWriter('4_morpho');
open(writerObj1);

n=20;

SE_dilate = strel('square', 21);
SE_erode = strel('disk', 41);
    
for k = 1 : considerFrames
    frame = read(xyloObj, k); 
    frame=(rgb2gray(frame));
  
    k=k
    
    im_conv=uint8( bwconvhull(frame,'objects')*255)  ;
    im_erode=uint8(imerode(im_conv,SE_erode));
    im_dilate=uint8(imdilate(im_erode,SE_dilate));
    
    writeVideo(writerObj1, uint8(im_dilate));
end

close(writerObj1);

%%%%%%%%% END OF MORPHOLOGY %%%%%%%%

%%%%%%%%% CONNECTECTED COMPONENTS AND FINDING COUNT %%%%%%%%

Obj = VideoReader('4_morpho.avi');
Obj1 = VideoReader('traffic_4.mp4');
writerObj1 = VideoWriter('4_connected');
writerObj2 = VideoWriter('4_connected_plus_orig');
writerObj2.FrameRate=25;

open(writerObj1);
open(writerObj2);

n=20;
% New - Create structuring element
se = strel('square', 3);

disp("Traffic count after every 2 seconds");
for k = 1 : considerFrames
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
    if(mod(k,60)==0)
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

%%%%%%%%% END OF CONNECTECTED COMPONENTS AND FINDING COUNT %%%%%%%%