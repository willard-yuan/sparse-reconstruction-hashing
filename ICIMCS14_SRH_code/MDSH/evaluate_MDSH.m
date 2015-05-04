function evaluation_info=evaluate_MDSH(Xtraining,Xtest,KNN_info,Param)

tmp_T=cputime;
Param = trainMDSH(Xtraining, Param);
traintime=cputime-tmp_T;
evaluation_info.trainT=traintime;

tmp_T=cputime;
[B_trn, U] = compressMDSH(Xtraining, Param);
[B_tst, U] = compressMDSH(Xtest, Param);
compressiontime=cputime-tmp_T;
evaluation_info.compressT=compressiontime;

% save param_SH.mat Param evaluation_info B_trn B_tst;
% load param_SH.mat;

%%
% ntraining=size(Xtraining,1);
RR=0;PP=0;
ntest=size(Xtest,1);
block_size=Param.block_size;
block_num=ntest/block_size;
for i_block=1:block_num
    fprintf('%d ', i_block);
    ibase=(i_block-1)*block_size;
    imax=min(i_block*block_size, ntest);
    BlockIdx=ibase+1:imax;
    Dhamm = hammingDist(B_tst(BlockIdx,:), B_trn);
    
    [foo, Rank] = sort(Dhamm, 2,'ascend');   
    Rank=single(Rank);
    if(iscell(KNN_info.knn_p2))
        trueRank=KNN_info.knn_p2(BlockIdx); 
        if(strcmp('ranking', Param.searchtype))
            eva_info = eva_ranking1(Rank, trueRank);
        else
            eva_info = eva_lookup1(Rank, trueRank, foo );
        end
    else
        trueRank=KNN_info.knn_p2(BlockIdx,:);
        if(strcmp('ranking', Param.searchtype))
            eva_info = eva_ranking(Rank, trueRank);
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

