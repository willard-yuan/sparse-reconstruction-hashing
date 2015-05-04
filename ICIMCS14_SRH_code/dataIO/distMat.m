function D=distMat(P1, P2)
%
% Euclidian distances between vectors
% each vector is one row
  
if nargin == 2
%     P1 = double(P1);
%     P2 = double(P2);
    P1 = single(P1);
    P2 = single(P2);
    
    X1=repmat(sum(P1.^2,2),[1 size(P2,1)]);
    X2=repmat(sum(P2.^2,2),[1 size(P1,1)]);
    R=P1*P2';
    D=single(real(sqrt(X1+X2'-2*R)));
else
%     P1 = double(P1);

    % each vector is one row
    X1=repmat(sum(P1.^2,2),[1 size(P1,1)]);
    R=P1*P1';
    D=X1+X1'-2*R;
    D = real(sqrt(D));
end

% %%%%thresholding
% %1)
% th=median(median(D));
% D(D>th)=0;

% %2)
% k=5;
% [Ds, Is]=sort(D, 2, 'descend');
% Ir=Is(k+1:end,:);
% [yy,xx]=size(Ir);
% Ix=1:yy;
% Ix=repmat(Ix',1,xx);
% I=sub2ind([yy,xx],Ix,Ir);
% Did=ones(size(D));
% Did(I)=0;
% if(size(D,1)==size(D,2))
%     Did=Did+Did';
% end
% D(Did==0)=0;

