%%% Unsupervised Sequential Projection Learning for Hashing (USPLH) 
%%% Reference: Jun Wang, Sanjiv Kumar, Shih-Fu Chang. Sequential Projection Learning
%%%% for Hashing with Compact Codes. In ICML, 2010
%%% by Jun Wang EE@Columbia (jwang@ee.columbia.edu);

function evaluation_info=evaluate_USPLH(SIFT_trndata,SIFT_tstdata,KNN_info,Param)

%%% Unsupervised Sequential Projection Learning for Hashing (USPLH) 

%%% Dependency 
%%% Param = trainUSPLH(trndata), Param); 
%%%              train hash functions

%%% Input:
%%%       --- SIFT_trndata:  input the training sift data set 1M X 128 matrix
%%%                       n by d matrix (n: number of samples; d: feature dimension)
%%%       --- SIFT_tstdata:  test data 10K X 128 matrix
%%%                       n by d matrix (n: number of samples; d: feature dimension);
%%%       --- KNN_info:   ground truth of nearest neighbor information
%%%                       for each test point, record the nearest 2% points
%%%                       in 1 M database, i.e. 20K
%%%                   knn_p2   sorted index of the ground truth 10K X 20K 
%%%                   dis_p2   sorted distance of the ground truth 10K X 20K 
%%%       --- Param: parameters of the algorithm
%%%                  nbits: number of hash bits
%%%                  eta:   sequential learning rate
%%%                  blocknum: the real tested queries in number of blocks  
%%% Output:
%%%       --- evaluation_info:    evaulation results;
%%%                trainT: training time
%%%                compressT: compression time
%%%                recall: recall curve
%%%                precision: precision of top [10, 50 100, 200, 300, 400, 500, 1000,2000,10000];
%%%                AP: average precision
%%%                APH2: mean precision in hamming radius 2
%%%                Param: strucutre to strore learned hash functions
%%% by J. Wang (jwang@ee.columbia.edu)
%%% Last update Sep, 2010

tmp_T=cputime;
Param = trainUSPLH(SIFT_trndata, Param);  %%% trani hash functions
%%% Training Time
traintime=cputime-tmp_T;
evaluation_info.trainT=traintime;

tmp_T=cputime;
% [npoint,ndim,nbat] = size(SIFT_trndata);  
%%% Compression Time
[B_trn, U] = compressUSPLH(SIFT_trndata, Param);  %%% compress hash codes for training data
[B_tst, U] = compressUSPLH(SIFT_tstdata, Param);  %%% compress hash codes for test data
compressiontime=cputime-tmp_T;
evaluation_info.compressT=compressiontime;

% save param_USPLH.mat Param evaluation_info B_trn B_tst;
% load param_USPLH.mat;

%%
RR=0;PP=0;
ntest=size(SIFT_tstdata,1);
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
% evaluation_info.SizeL=SizeL;
% %%
% D_code = hammingDist(B_tst,B_trn);
% [foo, j_code] = sort(D_code, 2,'ascend');
% if(strcmp('ranking', Param.searchtype))
%     evaluation_info = eva_Ranking( j_code, KNN_info );
% else
%     evaluation_info = eva_lookup( j_code, KNN_info, foo );
% end