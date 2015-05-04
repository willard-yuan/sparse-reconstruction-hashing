function [ evaluation_info ] = eva_lookup1( Rank, trueRank, Vr)

Radius=0:4;
[ntest, ntraining] = size(Rank);
HammIdx=single(zeros(ntest,length(Radius)));
for n=1:ntest
	for h=Radius
		idx=find(Vr(n,:)<h+1,1,'last');
		if(isempty(idx))
			if(h==0)
				idx=0;
			else
				idx=HammIdx(n,h);
			end
		end
		HammIdx(n,h+1)=idx;
	end
end

% trueRank = KNN_info.knn_p2;       
M_set=mean(HammIdx);

for n = 1:ntest  
    Rank(n,:) = ismember(Rank(n,:), trueRank{n});    
    Ntotal(n)=length(trueRank{n});
end

Ntotal(Ntotal==0)=ntraining;
for i=1:length(M_set)
    Pi=0;
    Ri=0;
    for n=1:ntest
        Nreturn=HammIdx(n,i);
        Ntrue=sum(Rank(n,1:Nreturn),2);
        if(Nreturn~=0)
            Pi=Pi+Ntrue/Nreturn;
        end
        Ri=Ri+Ntrue/Ntotal(n);
    end
    P(i)=Pi/ntest;
    R(i)=Ri/ntest;
end

evaluation_info.recall=R;
evaluation_info.precision=P;
evaluation_info.M_set=M_set;
