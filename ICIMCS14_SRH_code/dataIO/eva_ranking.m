function [ evaluation_info ] = eva_ranking( Rank, trueRank )

% trueRank = KNN_info.knn_p2;
%RankΪ500*50000��trueRankΪ500*1000����һ�ηֿ������ݵ���ĿΪ500
        
[ntest, ntraining] = size(Rank);

%params
%M_set=[10, 50 100, 200, 300, 400, 500, 1000,2000 4000 10000 20000 40000 60000 100000 140000 160000];%,10000];
%M_set=[10, 50 100, 200, 300, 400, 500, 1000,2000,3000,5000,7000,9000,10000,20000,30000,40000,50000,60000,70000,80000,90000,100000,110000,120000];
M_set=[10, 50 100, 200, 300, 400, 500, 1000,2000,3000,5000,7000,9000,10000,20000,30000,40000,59000];
%M_set=[500];
%M_set=[10, 50 100, 200, 300, 400, 500, 1000,2000 4000 6000 9000 12000 15000 18000 20000];
% jj = single(zeros(ntest, ntraining));
%M_set=[5,10,100,500,1000,1500,2000,3000,4000,5000,6000,8000,10000,11000,12000,14000,16000,20000,25000,30000,35000,40000,45000,50000,55000,60000,65000,70000,75000,80000,90000];

%�ж�Rank(n,:)�е�Ԫ���Ƿ�ΪtrueRank(n,:)�е�Ԫ��
for n = 1:ntest  
    Rank(n,:) = ismember(Rank(n,:), trueRank(n,:));    
end

truth_num=size(trueRank,2); %truth_num=1000  1000�����ڵ�
% comment the two lines below when plotting precision recall curve
Ri = single(cumsum(Rank,2)/truth_num); %cumsum(Rank,2)����ÿ�е��ۼӺͲ�����1000 
R = mean(Ri,1);   %����ȡƽ��

 for i_M=1:length(M_set)
     M=M_set(i_M);
     Ntrue=sum(Rank(:,1:M),2); %�ں����ռ��а���ͳ��ǰM����ԭŷʽ�ռ�����а��ϵ�ĸ���
     Pi=Ntrue/M;%����ÿ��������ݵ�ǰM���������м��������ڵı���  ����׼ȷ��
     P(i_M)=mean(Pi,1);%�����в�����ݵ�ǰM���������м��������ڵı���ȡƽ��
     Ri=Ntrue/truth_num;%�����ٻ���
     R(i_M)=mean(Ri,1);
 end

evaluation_info.recall=R;
evaluation_info.precision=P;
evaluation_info.M_set=M_set;
