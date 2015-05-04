function D=simMat(P1, P2)

%œ‡À∆–‘æÿ’Û

if nargin == 2   
    X1=repmat(sum(P1.^2,2),[1 size(P2,1)]);
    X2=repmat(sum(P2.^2,2),[1 size(P1,1)]);
    R=P1*P2';
    D=1./(1+single(real(sqrt(X1+X2'-2*R))));
else
    X1=repmat(sum(P1.^2,2),[1 size(P1,1)]);
    R=P1*P1';
    D=X1+X1'-2*R;
    D =1./(1+real(sqrt(D)));
end

