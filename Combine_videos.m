close all 
clc 
clear
vid1 = VideoReader('5_rgb2gray.avi'); 
vid2 = VideoReader('5_morpho.avi'); 
 
% New video 
outputVideo = VideoWriter('5_combine_rgb2gray_plus_morpho.avi'); 
outputVideo.FrameRate = vid1.FrameRate; open(outputVideo); 

while hasFrame(vid1) && hasFrame(vid2)
 img1 = readFrame(vid1); 
 img2 = readFrame(vid2); 
imgt = horzcat(img1, img2);
writeVideo(outputVideo, imgt);
 % play video step(videoPlayer, imgt);
 % record new video writeVideo(outputVideo, imgt); 
end
close(outputVideo);
