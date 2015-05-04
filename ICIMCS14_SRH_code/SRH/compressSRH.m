function [ T ] = compressSRH( X, A, B)

[Nsamples Ndim]=size(X);
U = X*A-repmat(B, [Nsamples 1]);
Xb=(U>0);
%Xb=(1+sign(X*A-B))/2;
T = compactbit(Xb);


