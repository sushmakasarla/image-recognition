%DESCRIPTION: This code implements PCA, Fisher LDA, and SVM to find matching faces.

% Clear memory and console
function out=PCA_LDA(a1)

     load './data2.mat'
     %Define variables
     k = 9;% Number of classes
     n = 10;% Number of images per class 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Principal Component Analysis (PCA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

display('Loading please wait...')

% Read images in T matrix
[nRow nCol M] = size(face);

% T is a matrix containing the reshaped vectors for each image
T = double(reshape(face,[nRow*nCol M]));

% mTot is the mean of the entire set of training images
mTot = mean(T,2);

% substract mean
A = T-repmat(mTot,1,M);

% Obtaining eigenvalues and eigenvectors of A'A
[V,D] = eig(A'*A);

% Obtaning more relevant eigenvalues and eigenvectors
eval = diag(D);

peval = [];
pevec = [];

for i = M:-1:k+1
    peval = [peval eval(i)];
    pevec = [pevec V(:,i)];
end

% Obtaining the eigenvectors
U = A * pevec; 

% Obtaining PCA weights
 Wpca = U'*A;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fisher's Linear Discriminant Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
% Obtaining Sb and Sw
cMean = zeros(M-k,M-k);
Sb = zeros(M-k,M-k);
Sw = zeros(M-k,M-k);

pcaMean = mean(Wpca,2);

for i = 1:k
    cMean = mean(Wpca(:,n*i-(n-1):n*i),2);
    Sb = Sb + (cMean-pcaMean)*(cMean-pcaMean)';
end

Sb = n*Sb;

for i = 1:k
    cMean = mean(Wpca(:,n*i-(n-1):n*i),2);
    for j = n*i-(n-1):n*i
         Sw = Sw + (Wpca(:,j)-cMean)*(Wpca(:,j)-cMean)';
    end
end

% Obtaining Fisher eigenvectors and eigenvalues
[Vf, Df] = eig(Sb,Sw);

% Calculating weights
 Df = fliplr(diag(Df));
 Vf = fliplr(Vf);

% Calculating fisher weights
Wf = Vf'*Wpca;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Euclidean Distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
    % Calculate euclidean distance
    %testNum = 134;

    % Normalize selected image
    %im=imread('6.jpg');
    Tr = double(reshape(a1,[nRow*nCol 1]));
    %Tr = double(reshape(face(:,:,testNum),[nRow*nCol 1]));
    Ar = Tr-mTot;

    % Obtain weights of the selected face
    Wrec = Vf'*U'*Ar;

    temp = 0;

    % Obtaining an array of euclidean distances to each face
    eDist = [];
    for i = 1:M
        eDist = [eDist sqrt(( norm( Wrec - Wf(:,i)) )^2)]; 
    end

    min={60751,69486,48673,52053,58029,60967,52281,38971,56581};
    % Find minimum distance and the corresponding index
    minDis = 999999;
    minIndex = 0;

    for i = 1:length(eDist)
        %display(eDist(i));
       if minDis > eDist(i)
           minDis = eDist(i);
           minIndex = i;
       end
    end
    %display(uint32(minDis));
    Matching_index = minIndex;
    if Matching_index==0
        display('no match found');
        out='';
    else
        display(Matching_index);
        conn=database('project','project','project');
        if mod(Matching_index,10)==0
            Matching_index=Matching_index/10;
        else
            Matching_index=int16(floor(Matching_index/10))+1;
        end
    display(Matching_index);
    s='select rollnumber,rownum rm from student';
    curs=exec(conn,s);
    curs=fetch(curs);
    rno=curs.data(Matching_index,1);
     s1=['select rollnumber from attendance where rollnumber= ''',rno{1},''' and Adate=to_char(sysdate,''dd-Mon-yyyy'')' ];
    curs1=exec(conn,s1);
    curs1=fetch(curs1);
    d=date;
    b=load('details.mat');
    day=b.t1;
    p=b.p;
    c={rno{1},d,day,'p'};
    if strcmp(curs1.data,'No Data')
        fastinsert(conn,'attendance',{'ROLLNUMBER','ADATE','DAY',p},[c(1),c(2),c(3),c(4)]);
    else
        update(conn,'attendance',{p},{'P'},[strcat('where rollnumber=',c(1))]);
    end
    % Plot selected face
    figure(1)
    imagesc(reshape(Tr,nRow,nCol));
    colormap gray;
    title('Face selected')
    
    % Plot best match
    figure(2)
    imagesc(reshape(T(:,minIndex),nRow,nCol));
    colormap gray;
    title('Best match')
    %else
     %   display('No Match Found');
    %end
    s=strcat(c(1),{' '},c(2),{' '},c(3),{' '},c(4));
    out=s;
    end
end
