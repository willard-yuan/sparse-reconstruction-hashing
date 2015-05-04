function [B, U] = compressUSPLH(X, USPLHparam)
%
% [B, U] = compresUSPLH(X, SHparam)
%
% Input
%   X = features matrix [Nsamples, Nfeatures]
%   SHparam =  parameters (output of trainSH)
%
% Output
%   B = bits (compacted in 8 bits words)
%   U = value of eigenfunctions (bits in B correspond to U>0)
%
%
% Spectral Hashing
% Y. Weiss, A. Torralba, R. Fergus. 
% Advances in Neural Information Processing Systems, 2008.

[Nsamples Ndim] = size(X);
nbits = USPLHparam.nbits;  
X = X*USPLHparam.w;
U = X-repmat(USPLHparam.b, [Nsamples 1]);
B = compactbit(U>0);
U = (U>0);
%[num, ave_num, max_num, min_num]=pcshsta(U>0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb = compactbit(b)
%
% b = bits array
% cb = compacted string of bits (using words of 'word' bits)

[nSamples nbits] = size(b);
nwords = ceil(nbits/8);
cb = zeros([nSamples nwords], 'uint8');

for j = 1:nbits
    w = ceil(j/8);
    cb(:,w) = bitset(cb(:,w), mod(j-1,8)+1, b(:,j));
end


