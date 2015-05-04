clear all;
clear;
load ./data/mnist_all.mat;
index=zeros(130,2);

rank=1;
left=0.005;
botton=0.895;
width=0.08;
height=0.08;

 for i=1:130
    image1r=train3(i,1:784);
    image1rr=reshape(image1r,28,28);
    %image1(:,:,1)=image1rr';
    image1=uint8(image1rr');
    if(mod(rank,13)~=0)
        hdl1=subplot(10,13,rank,'position',[left+0.07*(mod(rank,13)-1)  botton-0.09*fix(rank/13) width height]);
        imshow(image1);
    else
        hdl1=subplot(10,13,rank,'position',[left+0.07*12  botton-0.09*fix(rank/14) width height]);
        imshow(image1);
    end
%    subplot(7,11,i);
%    imshow(image1);
        rank=rank+1;
end