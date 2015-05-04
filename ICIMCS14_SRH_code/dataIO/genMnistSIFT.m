%%
clear all;
clc;
path(path,'dataIO');
path(path,'gistdescriptor');
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

% load ./data/mnist_all.mat;
% label0=0*ones(length(train0),1);
% label1=1*ones(length(train1),1);
% label2=2*ones(length(train2),1);
% label3=3*ones(length(train3),1);
% label4=4*ones(length(train4),1);
% label5=5*ones(length(train5),1);
% label6=6*ones(length(train6),1);
% label7=7*ones(length(train7),1);
% label8=8*ones(length(train8),1);
% label9=9*ones(length(train9),1);
% Xtraining=[train0,label0;train1,label1; ...
% train2,label2;train3,label3;train4,label4; ...
% train5,label5;train6,label6;train7,label7; ...
% train8,label8;train9,label9];
%gist=zeros(length(Xtraining),784);
% for i=1:length(Xtraining)
%     img=Xtraining(i,1:end-1);
%     param.orientationsPerScale = [8 8 8 8];
%     param.numberBlocks = 4;
%     param.fc_prefilt = 4;
%     [gist(i,:), param] = LMgist(img, '', param);
% end
%for i=1:length(database)
    for i=1:100
    img=database(i,1:end-1);
    param.orientationsPerScale = [8 8 8 8];
    param.numberBlocks = 4;
    param.fc_prefilt = 4;
    [gist(i,:), param] = LMgist(img, '', param);
end

