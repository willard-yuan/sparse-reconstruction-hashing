function S=simMat_sparse(X, mask)

[n, foo]=size(X);

S=single(sparse(n,n));
for i=1:n
    I=mask(i,:)>0;
    S0=simMat(X(i,:), X(I,:));
    S(i,I)=S0;
end
