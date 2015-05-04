function [ evaluation_info ] = eva_ranking1( Rank, trueRank )

% trueRank = KNN_info.knn_p2;
        
[ntest, ntraining] = size(Rank);

%params
M_set=[10, 50 100, 200, 300, 400, 500, 1000,2000];%,10000];

for n = 1:ntest  
    Rank(n,:) = ismember(Rank(n,:), trueRank{n});    
    Ntotal(n)=length(trueRank{n});
end

Ntotal(Ntotal==0)=ntraining;
CR=cumsum(Rank,2);
Ri = single(CR./repmat(Ntotal', 1, ntraining));
R = mean(Ri,1);

 for i_M=1:length(M_set)
     M=M_set(i_M);
     Ntrue=sum(Rank(:,1:M),2);
     Pi=Ntrue/M;
     P(i_M)=mean(Pi,1);
     Ri=Ntrue./Ntotal';
     R(i_M)=mean(Ri,1);
 end

evaluation_info.recall=R;
evaluation_info.ntrue=CR;
evaluation_info.precision=P;
%evaluation_info.precision=0;
evaluation_info.M_set=M_set;
