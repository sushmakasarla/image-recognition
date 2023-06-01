function test_group(im)
faceDetector = vision.CascadeObjectDetector();

% Read a video frame and run the detector.
%videoFileReader = vision.VideoFileReader('C:\Users\neelavani\Desktop\Face-Recognition-Using-Pca-master\group3.jpg');
%im=imread('C:\Users\neelavani\Desktop\PCA_LDA\group3.jpg');
%videoFrame      = getsnapshot(vid);
bbox            = faceDetector.step(im);

% Draw the returned bounding box around the detected face.
videoOut = insertObjectAnnotation(im,'rectangle',bbox,'Face');
%stop(videout);
figure, imshow(videoOut), title('Detected face');
pause(1);
t=['ROLLNUMBER  ','DATE            ','DAY           ','ATTENDANCE'];
for i=1:size(bbox,1)
    
    im1=imcrop(videoOut,bbox(i,:));
    %im1=im1+50;
    im1=rgb2gray(im1);
    imshow(im1);
    pause(1);
    a1=imresize(im1,[34 28]);
    %a1=imadjust(a1);
    imshow(a1);
    pause(2);
    imwrite(a1,strcat('C:\Users\NarsiReddy\Desktop\PCA_LDA\libsvm\',num2str(i),'.jpg'));
    a1=imread(strcat('C:\Users\NarsiReddy\Desktop\PCA_LDA\libsvm\',num2str(i),'.jpg'));
    c=PCA_LDA(a1);
    t=[t;c];
    pause(2);
    %imwrite(a1,strcat('C:\Users\neelavani\Desktop\PCA_LDA\',num2str(i+4),'.jpg'));
end
msgbox(t,'Attendance');

%eigenface_mymethod_testing();
%eigenfacetest();
end