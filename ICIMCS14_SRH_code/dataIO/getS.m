function S = getS( X )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numColu=size(X,1);
S=zeros(numColu);
for i=1:numColu
    for j=1:numColu
        if (X(i,1)==X(j,1))
            S(i,j)=1;
        else
            S(i,j)=-1;
        end
    end
end
S=S-diag(diag(S));      
end

