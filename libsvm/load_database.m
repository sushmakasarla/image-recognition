function face=load_database()
% We load the database the first time we run the program.
delete('data2.mat');
persistent loaded;
if(isempty(loaded))
    cd('.\dataset');
    t=rgb2gray(imread('1.jpg'));
    t=imresize(t,[34 28]);
    
    for i=2:90
       
            a=double(rgb2gray(imread(strcat(num2str(i),'.jpg'))));
            a=imresize(a,[34 28]);
            t=cat(3,t,a);
       
    end
 
end
loaded=1;  % Set 'loaded' to aviod loading the database again. 
face = t;
cd ..
save data2.mat face;
end

