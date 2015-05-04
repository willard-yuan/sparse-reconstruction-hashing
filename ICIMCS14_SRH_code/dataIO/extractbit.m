function b = extractbit(cb)

[nSamples nwords] = size(cb);
nbits = nwords*8;
b = zeros([nSamples nbits], 'uint8');

for w = 1:nwords
    j0=(w-1)*8;
    for j=1:8;
        b(:,j0+j)=bitget(cb(:,w), j);
    end
end