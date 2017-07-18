%  Created by Badrun Nahar on 2012.
%  Copyright © 2012 Badrun Nahar (Concordia University). All rights reserved.

%{
    Following source code is the MATLAB implementation of the Masters thesis 
    "Contrast enhancement with the noise removal by a discriminative filtering process"
    where a novel approach of low-pass filtering is developed based on multiple stages of median filtering and 
    threshold based image clustering. The input of the filtering algorithm is a low contrast image which is first 
    enhanced by a variant of histogram equalization (CLAHE). Then the developed algorithm detects different levels 
    of noisy regions in that enhanced image and selectively apply low-pass filtering over those regions based on their
    noise levels while protecting high frequency edge regions. In that way, the algorithm is able to discriminatively 
    smooth noisy pixels by maintaining preservation of edges. For further understanding, find the thesis at 
    http://spectrum.library.concordia.ca/974797/
%}

tic;

input_image= imread('C:\Users\bnahar\example_image.jpg'); 
 
A1=rgb2gray(input_image);
cliplimit_cla=0.08;
grid_size=[8 8];
figure, imshow(A1),title('input image');
figure, imhist(A1),title('input image histogram');

%%% CLAHE Enhanced Image
enhanced_A=adapthisteq(A1,'ClipLimit',cliplimit_cla,'NumTiles',grid_size); 
figure,imshow(enhanced_A),title('After CLAHE');
enhanced_A1=double(enhanced_A)/255; filt_gaussian=fspecial('gaussian', [5 5], 0.5); 
enhanced_A12=imfilter(enhanced_A1,filt_gaussian,'conv','replicate');
figure, imshow(enhanced_A12),title('pre-filtered output'); 

%%%  Size adjustment with zero padding
[m n]=size(A1);
x1=zeros(m+4,n+4);
x1(3:m+2,3:n+2)=enhanced_A12(:,:);
x1(1,3:n+2)=enhanced_A12(1,1:n);
x1(2,3:n+2)=enhanced_A12(1,1:n);
x1(m+3,3:n+2)=enhanced_A12(m,1:n);
x1(m+4,3:n+2)=enhanced_A12(m,1:n);
x1(3:m+2,1)=enhanced_A12(1:m,1);
x1(3:m+2,2)=enhanced_A12(1:m,1);
x1(3:m+2,n+3)=enhanced_A12(1:m,n);
x1(3:m+2,n+4)=enhanced_A12(1:m,n);
x1(1,1)=enhanced_A12(1,1);
x1(1,2)=enhanced_A12(1,1);
x1(2,1)=enhanced_A12(1,1);
x1(2,2)=enhanced_A12(1,1);
x1(1,n+3)=enhanced_A12(1,n);
x1(1,n+4)=enhanced_A12(1,n);
x1(2,n+3)=enhanced_A12(1,n);
x1(2,n+4)=enhanced_A12(1,n);
x1(m+3,1)=enhanced_A12(m,1);
x1(m+3,2)=enhanced_A12(m,1);
x1(m+4,1)=enhanced_A12(m,1);
x1(m+4,2)=enhanced_A12(m,1);
x1(m+3,n+3)=enhanced_A12(m,n);
x1(m+3,n+4)=enhanced_A12(m,n);
x1(m+4,n+3)=enhanced_A12(m,1);
x1(m+4,n+4)=enhanced_A12(m,1);


%%% Clustering original image

d=zeros(size(A1));
for i=1:m*n
    if (A1(i)>=0 && A1(i)<=20)||(A1(i)>=210 && A1(i)<=250)
        d(i)=1;
    else d(i)=0;
    end 
end

figure,imshow(d),title('gray level thresholding');


%%% Region Correction for low-pass2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count1=8*ones(m+4,n+4);
count2=8*ones(m+4,n+4);
d1=zeros(m+4,n+4);
d1(3:m+2,3:n+2)=d(:,:);
d2=d1;
d3=d1;
for i=3:m+2
    for j=3:n+2
        if d1(i,j)==0
          count1(i,j)=count1(i,j)-(d1(i-1,j-1)+d1(i-1,j)+d1(i-1,j+1)+d1(i,j- 1) ...
                       +d1(i,j+1)+d1(i+1,j-1)+d1(i+1,j)+d1(i+1,j+1));
           if count1(i,j)<=1
             d2(i,j)=1;
           % elseif ((d1(i-1,j-1)==d1(i-1,j+1)==d1(i+1,j+1)==d1(i+1,j-1)) && ...
           % (d1(i- 1,j)==d1(i,j+1)==d1(i+1,j)==d1(i,j-1)))&& (d1(i-1,j-1)~=d1(i-1,j))
           % d2(i,j)=1;
           end 
        end
    end
end

figure,imshow(d2(3:m+2,3:n+2)),title('Group-1 & Group-3 corrected for low-pass2');


%%% Region correction for low-pass1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Group-1,group-3 & Group-2 with some preservation correction

for i=3:m+2
    for j=3:n+2
        if d1(i,j)==0 
           count2(i,j)= count2(i,j)-(d1(i-1,j-1)+d1(i-1,j)+d1(i-1,j+1) ...
                        +d1(i,j-1)+d1(i,j+1)+d1(i+1,j-1)+d1(i+1,j)+d1(i+1,j+1));
           if count2(i,j)<=3

        %{ if ((d1(i+1,j)==d1(i+1,j+1)==d1(i,j+1)==0)||(d1(i,j+1)==d1(i-1,j+1)==d1(i-1,j)==0)...
                           ||(d1(i,j-1)==d1(i-1,j-1)==d1(i-1,j)==0)||(d1(i,j-1)==d1(i+1,j-1)==d1(i+1,j)==0))
                d3(i,j)=0;
           else d3(i,j)=1;
           end
           elseif count2(i,j)<=2
        %}
 
           d3(i,j)=1;
        
           elseif ((d1(i-1,j-1)==d1(i-1,j+1)==d1(i+1,j+1)==d1(i+1,j-1)) && (d1(i-1,j)==d1(i,j+1)==d1(i+1,j)==d1(i,j-1))) ...
                && (d1(i-1,j-1)~=d1(i-1,j)) 
                d3(i,j)=1;

           end
        end
    end
end

figure,imshow(d3(3:m+2,3:n+2)),title('Group-1,Group-3 & Group-2 with some preservation corrected: R. C. for low-pass1');

%%% Discriminative filtering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filtered_A123=zeros(m+4,n+4);

%low-pass 1, binary mask d3(3:m+2,3:n+2)

for i=3:m+2
    for j=3:n+2
       if d3(i,j)==1
          hor_ver_data= [x1(i,j-2) x1(i,j-1) x1(i,j+1) x1(i,j+2) x1(i-2,j) x1(i-1,j) ...
                         x1(i+1,j) x1(i+2,j) x1(i,j)]; 
          Mr = median(hor_ver_data);
          diag_data = [x1(i-2, j-2) x1(i-1, j-1) x1(i+1,j+1) x1(i+2,j+2) x1(i+1,j-1) ...
                       x1(i+2,j-2) x1(i-1,j+1) x1(i-2,j+2) x1(i,j)]; Md=median(diag_data); 
          vect1=[Mr Md x1(i,j)];
          filtered_A123(i,j)= median(vect1);
        else 
          filtered_A123(i,j)=x1(i,j);
        end
    end 
end

filtered_A1234=zeros(m+4,n+4);

%low-pass 2, binary mask d2(3:m+2,3:n+2)

for i=3:m+2
    for j=3:n+2
        if d2(i,j)==1
           hor_ver_data1= [filtered_A123(i,j-2) filtered_A123(i,j-1) filtered_A123(i,j+1) ... 
                           filtered_A123(i,j+2) filtered_A123(i-2,j) filtered_A123(i-1,j) ...
                           filtered_A123(i+1,j) filtered_A123(i+2,j) ]; 
           Mr1=median(hor_ver_data1);

           diag_data1 = [filtered_A123(i-2, j-2) filtered_A123(i-1, j-1) filtered_A123(i+1,j+1) ... 
                         filtered_A123(i+2, j+2) filtered_A123(i+1,j-1) filtered_A123(i+2, j-2) ...
                         filtered_A123(i-1,j+1) filtered_A123(i-2, j+2) ]; 
           Md1=median(diag_data1);

           vect2=[Mr1 Md1 filtered_A123(i,j)];
           filtered_A1234(i,j)= median(vect2);

        else 
           filtered_A1234(i,j)= filtered_A123(i,j);
        end
    end 
end

filtered_A12345=zeros(m+4,n+4);

%low-pass 3, binary mask d2(3:m+2,3:n+2)

for i=3:m+2
    for j=3:n+2
       if d2(i,j)==1
          hor_ver_data2= [filtered_A1234(i,j-2) filtered_A1234(i,j-1) filtered_A1234(i,j+1) ...
                          filtered_A1234(i,j+2) filtered_A1234(i-2,j) filtered_A1234(i-1,j) ...
                          filtered_A1234(i+1,j) filtered_A1234(i+2,j)]; 
          Mr2=median(hor_ver_data2);

          diag_data2 = [filtered_A1234(i-2, j-2) filtered_A1234(i-1, j-1) filtered_A1234(i+1,j+1) ... 
                        filtered_A1234(i+2,j+2) filtered_A1234(i+1,j-1) filtered_A1234(i+2,j- 2) ...
                        filtered_A1234(i-1,j+1) filtered_A1234(i-2,j+2)]; 
          Md2=median(diag_data2);

          vect3=[Mr2 Md2 filtered_A1234(i,j)];
          filtered_A12345(i,j)= median(vect3);

        else 
          filtered_A12345(i,j)= filtered_A1234(i,j);
        end
    end 
end

figure,imshow(d3(3:m+2,3:n+2)),title('region corrected mask for low-pass1'); 
figure,imshow(d2(3:m+2,3:n+2)),title('region corrected mask for low-pass2'); 
%figure,imshow(d3-d2);
figure,imshow(filtered_A123(3:m+2,3:n+2)), title('output of 1st stage of discriminative filtering by 5x5 BMM');
figure,imshow(filtered_A1234(3:m+2,3:n+2)), title('output of 2nd stage of discriminative filtering by 5x5 BMM')

toc;

%figure,imshow(filtered_A12345(3:m+2,3:n+2)), title('output of 3rd stage by 5X5 mult med'); 
%toc;

