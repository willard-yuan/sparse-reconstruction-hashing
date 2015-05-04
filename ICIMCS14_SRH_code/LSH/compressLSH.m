function B =compressLSH(X,I)

% switch type,
%     case 'lsh',
%         U = X(:,I.d) <= repmat(I.t,size(X,1),1);
% 
%     case 'e2lsh',
% %         U = floor((double(X)*I.A - repmat(I.b,size(X,1),1))/I.W);
%         U = X*I.A - repmat(I.b,size(X,1),1);
% end

U = X*I.A;
B = compactbit(U>0);