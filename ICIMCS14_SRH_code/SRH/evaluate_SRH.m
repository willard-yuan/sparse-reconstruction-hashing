function evaluation_info =evaluate_SRH(Xtraining,Xtest,KNN_info,Param)

tmp_T=cputime;
Param = trainSRH(Xtraining, Param);
traintime=cputime-tmp_T;
evaluation_info.trainT=traintime;

ntest=size(Xtest,1);
ntraining=size(Xtraining,1);
L=size(Param.A,2);
II=1:ntraining;

tmp_T=cputime;
for j=1:L
    B_tst{j} = compressSRH( Xtest, Param.A{j}, Param.B{j} );
    B_trn{j} = compressSRH( Xtraining, Param.A{j}, Param.B{j} );
    Mask{j}=setdiff(II,Param.Mask{j});
    SizeL(j)=length(Param.Mask{j});
end
compressiontime=cputime-tmp_T;
evaluation_info.compressT=compressiontime;

%%
RR=0;PP=0;
block_size=Param.block_size;     %block_size=500 块的大小
block_num=ntest/block_size;           %10000/500=20   分块的数目
for i_block=1:block_num           %1:20
    fprintf('%d ', i_block);
    D=zeros(block_size,ntraining,'uint8');  %500*50000的0矩阵
    D=D+inf;                                                   %500*50000元素全为255的矩阵
    D2=zeros(block_size,ntraining,'single');  %500*50000的0矩阵
    ibase=(i_block-1)*block_size;     %0、500、1000、1500、2000、···、9500
    imax=min(i_block*block_size, ntest);   %i_block*500,10000; imax=i_block*500
    BlockIdx=ibase+1:imax;     %(i_block,BlockIdx)，(1,1:500)，(2,501:1500)，
    %(3,1001:2500)，(4,1501:3500)，(5,2001:4500), ```,(20,9501:19500)
    for j=1:L
        Dhamm = hammingDist(B_tst{j}(BlockIdx,:), B_trn{j});  %测试数据分块后块中数据点
        % 与训练数据的汉明距离Dhamm BlockIdx的长度*5000
        if(Param.doMask)
            Dhamm(:,Mask{j})=inf;
        end
        D=min(Dhamm,D);     %D BlockIdx的长度*5000   这一步的目的是使Dhamm
        %的上限不要超过255(2^8=256)
        D2=D2+single(Dhamm);   %D2 BlockIdx的长度*5000  L个哈希表汉明距离累加
    end
    D2=D2/(max(max(D2))+1);     %归一化？？？
    D2=single(D)+D2;
    [foo, Rank] = sort(D2, 2,'ascend');    %foo为汉明距离按每行由小到大排序
    %Rank是对应排序前的位置
    
    Rank=single(Rank);
    if(iscell(KNN_info.knn_p2))  %iscell(KNN_info.knn_p2)=0
        trueRank=KNN_info.knn_p2(BlockIdx);
        if(strcmp('ranking', Param.searchtype))
            eva_info = eva_ranking1(Rank, trueRank);
        else
            eva_info = eva_lookup1(Rank, trueRank, foo );
        end
    else
        trueRank=KNN_info.knn_p2(BlockIdx,:);     %执行这个 KNN_info.knn_p2为10000*1000，
        %10000为测试数据点，1000为对应训练数据中与该测试数据点的1000个近邻
        if(strcmp('ranking', Param.searchtype))    %为真
            eva_info = eva_ranking(Rank, trueRank);   %执行这个
        else
            eva_info = eva_lookup(Rank, trueRank, foo );
        end
    end
    
    %     Ri(i_block,:)=eva_info.recall;
    %     Pi(i_block,:)=eva_info.precision;
    %     Mi(i_block,:)=eva_info.M_set;
    
    RR=RR+eva_info.recall;
    PP=PP+eva_info.precision;
end

% evaluation_info.recall=mean(Ri);
% evaluation_info.precision=mean(Pi);
% evaluation_info.M_set=mean(Mi);
evaluation_info.recall=RR/block_num;
evaluation_info.precision=PP/block_num;
evaluation_info.M_set=eva_info.M_set;
evaluation_info.SizeL=SizeL;
