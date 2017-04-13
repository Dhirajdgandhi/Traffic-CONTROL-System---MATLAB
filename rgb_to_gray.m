xyloObj = VideoReader('traffic_4.mp4');
writerObj = VideoWriter('4_rgb2gray');
writerObj.FrameRate=30;

open(writerObj);

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

considerFrames=nFrames;

for k = 1 : considerFrames
    k=k
    frame = read(xyloObj, k);
    frame=(rgb2gray(frame));
    frame=imresize(frame,[360 480]);
    writeVideo(writerObj, frame);
end

close(writerObj);

