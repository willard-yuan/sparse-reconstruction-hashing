clear all;
clc;
path(path,'USPLH');  % our method
path(path,'dataIO');
dataset='./data/Data_cifar.mat';

c_num=1000;
epsilon=0.002;
USPLH_lambda=0.125;
USPLH_cnum=2000;

if(exist('Xtraining','var')==0)
    load(dataset, 'Xtraining');
end
if(exist('Xtest','var')==0)
    load(dataset, 'Xtest');
end
if(exist('KNN_info','var')==0)
    load(dataset, 'KNN_info');
end

loopbits=32;
param.block_size=1000;
param.nbits=loopbits;


fprintf('\nUSPLH...\n');
USPLHparam=param;
USPLHparam.eta=1;
USPLHparam.lambda=USPLH_lambda;
USPLHparam.c_num=USPLH_cnum;
ntest=size(Xtest,1);
ntraining=size(Xtraining,1);
Param =  trainUSPLH(Xtraining, USPLHparam);

[B_trn, U] = compressUSPLH(Xtraining, Param);
[B_tst, U] = compressUSPLH(Xtest, Param);
%%
block_size=USPLHparam.block_size;
block_num=ntest/block_size;
for i_block=1:block_num
    fprintf('%d ', i_block);
    D=zeros(block_size,ntraining,'uint8');
    D=D+inf;
    block_size=param.block_size;     %block_size=500 块的大小
    ibase=(i_block-1)*block_size;     %0、500、1000、1500、2000、···、9500
    imax=min(i_block*block_size, ntest);   %i_block*500,10000; imax=i_block*500
    BlockIdx=ibase+1:imax;     %(i_block,BlockIdx)，(1,1:500)，(2,501:1500)，
    %(3,1001:2500)，(4,1501:3500)，(5,2001:4500), ```,(20,9501:19500)
    Dhamm = hammingDist(B_tst(BlockIdx,:), B_trn);
    D=min(Dhamm,D);
    [foo, Rank] = sort(D, 2,'ascend');
    %Rank是对应排序前的位置
end

%% show retrieval images
load ./data/cifar-10-batches-mat/data_batch_1.mat;
data1=data;
labels1=labels;
clear data labels;
load ./data/cifar-10-batches-mat/data_batch_2.mat;
data2=data;
labels2=labels;
clear data labels;
load ./data/cifar-10-batches-mat/data_batch_3.mat;
data3=data;
labels3=labels;
clear data labels;
load ./data/cifar-10-batches-mat/data_batch_4.mat;
data4=data;
labels4=labels;
clear data labels;
load ./data/cifar-10-batches-mat/data_batch_5.mat;
data5=data;
labels5=labels;
clear data labels;
load ./data/cifar-10-batches-mat/test_batch.mat;
data6=data;
labels6=labels;
clear data labels;
database=[data1 labels1 ;data2 labels2;data3 labels3;data4 labels4;data5 labels5;data6 labels6];
cifar10labels=[labels1;labels2;labels3;labels4;labels5;labels6];
save('./data/cifar10labels.mat','cifar10labels');
%index=[50001,Rank(1,1:129)]'; %50001是猫
%index=[50002,Rank(2,1:129)]'; %50002是船
%index=[59004,Rank(4,1:129)]'; %59004是猫
%index=[59005,Rank(5,1:129)]'; %马
%index=[59006,Rank(6,1:129)]'; %狗
%index=[59018,Rank(18,1:129)]'; % 飞机
index=[59046,Rank(46,1:35)]'; % 飞机
%index=[59018,Rank(18,1:35)]'; % 飞机
%index=Rank(9,1:36)'; % 飞机
%index=[59018,Rank(18,1:129)]'; % 飞机
%index=[50007,Rank(7,1:129)]'; %50007是automobile
rank=1;
%left=0.005;
left=0.1;
botton=0.8;
width=0.08;
height=0.08;

%     for i=1:130
%         j=index(i,1);
%         image1r=database(j,1:1024);
%         image1g=database(j,1025:2048);
%         image1b=database(j,2049:end-1);
%         image1rr=reshape(image1r,32,32);
%         image1gg=reshape(image1g,32,32);
%         image1bb=reshape(image1b,32,32);
%         image1(:,:,1)=image1rr';
%         image1(:,:,2)=image1gg';
%         image1(:,:,3)=image1bb';
%         image1=uint8(image1);
%         if(mod(rank,13)~=0)
%             hdl1=subplot(10,13,rank,'position',[left+0.07*(mod(rank,13)-1)  botton-0.09*fix(rank/13) width height]);
%             imshow(image1);
%         else
%             hdl1=subplot(10,13,rank,'position',[left+0.07*12  botton-0.09*fix(rank/14) width height]);
%             imshow(image1);
%         end
%         %    subplot(7,11,i);
%         %    imshow(image1);
%         rank=rank+1;
%     end
for i=1:36
    j=index(i,1);
    image1r=database(j,1:1024);
    image1g=database(j,1025:2048);
    image1b=database(j,2049:end-1);
    image1rr=reshape(image1r,32,32);
    image1gg=reshape(image1g,32,32);
    image1bb=reshape(image1b,32,32);
    image1(:,:,1)=image1rr';
    image1(:,:,2)=image1gg';
    image1(:,:,3)=image1bb';
    image1=uint8(image1);
    if(mod(rank,6)~=0)
        hdl1=subplot(6,6,rank,'position',[left+0.07*(mod(rank,6)-1)  botton-0.09*fix(rank/6) width height]);
        imshow(image1);
    else
        hdl1=subplot(6,6,rank,'position',[left+0.07*5  botton-0.09*fix(rank/7) width height]);
        imshow(image1);
    end
    %    subplot(7,11,i);
    %    imshow(image1);
    rank=rank+1;
end
