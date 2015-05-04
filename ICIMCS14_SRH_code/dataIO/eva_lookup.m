function [ evaluation_info ] = eva_lookup( Rank, trueRank, Vr)

 %Radius=0:4;
Radius=2; %汉明半径
[ntest, ntraining] = size(Rank);
HammIdx=single(zeros(ntest,length(Radius)));
for n=1:ntest
    for h=Radius
%         idx=find(Vr(n,:)<h+1,1,'last');    %返回最后一个小于h+1的数据索引 源程序
        idx=find(Vr(n,:)<h,1,'last');    %返回最后一个小于h+1的数据索引
        if(isempty(idx))
            if(h==0)
                idx=0;
            else
                idx=HammIdx(n,h-1);     %原程序
 %               idx=HammIdx(n,h-1);  %Radius=2
 %               idx=HammIdx(n,h-3);  %Radius=4
            end
        end
             HammIdx(n,h-1)=idx;   %Radius=1
%         HammIdx(n,h+1)=idx;   %原程序
%         HammIdx(n,h-1)=idx;    %Radius=2
%         HammIdx(n,h-3)=idx;    %Radius=4
    end
end

% trueRank = KNN_info.knn_p2;       
M_set=mean(HammIdx);

for n = 1:ntest  
    Rank(n,:) = ismember(Rank(n,:), trueRank(n,:));   %判断Rank是否为trueRank的子集
end

Ntotal=size(trueRank,2);
for i=1:length(M_set)
    Pi=0;
    Ri=0;
    for n=1:ntest
        Nreturn=HammIdx(n,i);
        Ntrue=sum(Rank(n,1:Nreturn),2);
        if(Nreturn~=0)
            Pi=Pi+Ntrue/Nreturn;
        end
            Ri=Ri+Ntrue/Ntotal;
    end
    P(i)=Pi/ntest; %对所有测试样本的检索准确率总和求平均
    R(i)=Ri/ntest;
end

evaluation_info.recall=R;
evaluation_info.precision=P;
evaluation_info.M_set=M_set;
