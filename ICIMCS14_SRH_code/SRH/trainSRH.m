function Param = trainSRH(X, Param)
[Nsamples Ndim] = size(X);
M=X'*X;
opts.disp=0.01;
[V,D] = eigs(double(M), Param.nbits, 'LM', opts);
V=single(V);
Param.B{1}=median(X*V,1);
Param.A{1}=V;
Param.Mask{1}=uint32(1:Nsamples);

if(Param.L>1)
    [X_sup, S, I_sup, I_keep]=getSubinfo(X,Param);
end
[TT,YYY]=size(X_sup);
DD=ones(TT);
itr=1;
LL=single(zeros(TT,TT));
while(itr<Param.L)
    itr=itr+1;
    for ii=1:5
    M1=X_sup'*S*X_sup;
    M2=X(I_keep,:)'*X(I_keep,:);
    M3=X_sup'*(eye(TT)-DD-DD'+DD*DD')*X_sup;
    M= M3/(M1+Param.eta*M2);
    [V,D] = eigs(double(M), Param.nbits, 'SM', opts);
    for i=1:TT
        LL(i,i)=0.5/sqrt(sum(DD(i,:)*DD(i,:)',2)+eps);
    end
    B=X_sup*V;
     DD=(B*B')*inv(B*B'+Param.alpha*LL);
    end
       
    V=single(V);
    Param.B{itr}=median(X*V,1);
    Param.A{itr}=V;	
    Param.Mask{itr}=I_keep;
      
    if(itr<Param.L)
        [X_sup, S, I_sup, I_keep]=getSubinfo(X,Param);
        if(length(I_sup)<10)
            fprintf('converged in itration %d\n', itr);
            break;
        end
    end
end

function [X_sup, S, I_sup, I_keep]=getSubinfo(X, Param)

[Nsamples Ndim]=size(X);

RR=zeros(Nsamples,1,'single');
for i=1:length(Param.A)
    A=Param.A{i};
    B=Param.B{i};
    U=X*A-repmat(B, [Nsamples 1]);
    R=min(abs(U),[],2);
    RR=max(RR,R);
end
[foo,I]=sort(RR);
I_sup=uint32(I(1:Param.c_num));
p_num=find(foo>Param.epsilon,1);
if(isempty(p_num))
    fprintf('p_num=0\n');
    I_keep=[];
else
    fprintf('p_num=%d\n',p_num);
    I_keep=uint32(I(1:p_num));
end
I_keep=union(I_keep,I_sup);

ns=length(I_sup);
X_sup=X(I_sup,:);

DD=zeros(ns,ns,'uint8');
DD=DD+inf;
for i=1:size(Param.A,2)
    B = compressSRH( X_sup, Param.A{i}, Param.B{i} );
    D = hammingDist(B, B);
    DD = min(DD,D);
end

M=simMat(X_sup);
M=M.*single(DD);
S=M;
