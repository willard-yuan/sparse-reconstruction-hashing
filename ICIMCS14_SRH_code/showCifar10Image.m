clear all;
clear;
load ./data/cifar-10-batches-mat/data_batch_2.mat;
index=zeros(130,2);
for i=0:9
    index((13*i+1):13*(i+1),:)=[find(labels==i,13),i*ones(13,1)];
end
rank=1;
left=0.005;
botton=0.895;
width=0.08;
height=0.08;

 for i=1:130
     j=index(i,1);
    image1r=data(j,1:1024);
    image1g=data(j,1025:end-1024);
    image1b=data(j,2049:end);
    image1rr=reshape(image1r,32,32);
    image1gg=reshape(image1g,32,32);
    image1bb=reshape(image1b,32,32);
    image1(:,:,1)=image1rr';
    image1(:,:,2)=image1gg';
    image1(:,:,3)=image1bb';
    image1=uint8(image1);
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