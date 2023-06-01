function face=load_data()
% We load the database the first time we run the program.
delete('data2.mat');
persistent loaded;
persistent w;
if(isempty(loaded))
    %v=zeros(112,92,90);
    %v=cell(112,92,90);
    
    cd('.\dataset');
    t=double(rgb2gray(imread('1.jpg')));
    t=imresize(t,[24 21]);
    %t=imadjust(t);
    
    for i=2:90
       
            a=double(rgb2gray(imread(strcat(num2str(i),'.jpg'))));
            a=imresize(a,[24 21]);
            %a=imadjust(a);
            t=cat(3,t,a);
            
            %v=reshape(a,[size(a,1)*size(a,2) size(a,3)]);
                  
        
    end
    %w=uint8(v); % Convert to unsigned 8 bit numbers to save memory. 
end
loaded=1;  % Set 'loaded' to aviod loading the database again. 
%display(size(v));
face = t;
cd ..
save data2.mat face;
end

