% xyloObj = VideoReader('amb.mp4');
% 
% writerObj1 = VideoWriter('amb_red');
% open(writerObj1);
% 
% nFrames = xyloObj.NumberOfFrames;
% vidHeight = xyloObj.Height;
% vidWidth = xyloObj.Width;
% 
% considerFrames=nFrames;
% n=10;

%for k = 1 : considerFrames
    frame = imread('amb3.jpg'); 
    frame = imresize(frame,[360,480]);
    %frame=(rgb2gray(frame));
  
    %z=double(zeros(vidHeight,vidWidth,3));
    
   
    %im_sub=uint8(imbinarize(im_sub,0.10)*255);  %BEST TILL NOW
    %for i = 1 : 3
    other_thresh=50;
    blue_other_thresh=100;
    red_thresh=180;
    blue_thresh=180;
    
    red=frame(:,:,1);
    red(and(and(frame(:,:,1)>=red_thresh,frame(:,:,2)<=other_thresh),frame(:,:,3)<=other_thresh) )=255;
    red(and(or(frame(:,:,3)>=other_thresh,frame(:,:,2)>other_thresh),frame(:,:,1)>red_thresh) )=0;   
    red(frame(:,:,1)<red_thresh)=0;
    
    blue=frame(:,:,3);
    blue(and(and(frame(:,:,3)>=blue_thresh,frame(:,:,1)<=blue_other_thresh),frame(:,:,2)<=blue_other_thresh) )=255;
    blue(and(or(frame(:,:,1)>=blue_other_thresh,frame(:,:,2)>blue_other_thresh),frame(:,:,3)>blue_thresh) )=0;   
    blue(frame(:,:,3)<blue_thresh)=0;
%     
    green=frame(:,:,2)*0;
%     green(frame(:,:,3)<=30)=255; 
%     green(frame(:,:,3)30)=0;
    
    %end
    SE=strel('square',11);
    
    red_frame=cat(3,red,green*0,blue*0);
    figure;imshow(red_frame);
    red_frame=im2bw(red_frame,0.2);
    red_frame=imopen(red_frame,SE);
    
    
    blue_frame=cat(3,red*0,green*0,blue);
    figure;imshow(blue_frame);
    blue_frame=im2bw(blue_frame,0.1);
    blue_frame=imopen(blue_frame,SE);
    
   
    CC = bwconncomp(red_frame,8);
    num1=CC.NumObjects;
    
    rowredcomp=[];
    colredcomp=[];
    S = regionprops(CC,'Centroid');
    redCentroids=[S];
    %disp("Red Centroids"+redCentroids)
    
%     for i = 1:num
%         a,b=S.Centroid(i);
%         rowredcomp=[rowredcomp,a];
%         colredcomp=[colredcomp,b];
%     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    CC = bwconncomp(blue_frame,8);
    num2=CC.NumObjects;
    rowbluecomp=[];
    colbluecomp=[];
    S = regionprops(CC,'Centroid');
    blueCentroids=[S];
    %disp("Blue Centroids"+blueCentroids)
    
%     for i = 1:num2

%         a,b=S.Centroid;;
%         rowbluecomp=[rowbluecomp,a];
%         colbluecomp=[colbluecomp,b];
%     end
    
    
    
    total=0;
    dis=[];
    for i=1: num1
        for j=1:num2
            new_dis=pdist2(redCentroids(i).Centroid,blueCentroids(j).Centroid);
            if new_dis<100
                total=total+1;
            end   
            dis = [dis,new_dis ]; 
            
        end
    end
    
    dis=dis;
    disp("Total number of ambulance in image = "+total);
   
    %[r, c] = find(L==1);
    %rc = [r c];
    
    %writeVideo(writerObj1, frame);
% end
% 
% %bgrnd_img=uint8(bgrnd_img);
% close(writerObj1);