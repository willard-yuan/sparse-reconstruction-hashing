%function [er] = expectedRank(Wtrue, What, fig, varargin)
function [er] = expectedRankEfficient(Xtraining, Xtest, Utraining, Utest, SHparam, T, fig, varargin)
%
% Input:
%    Wtrue = true neighbors [Ntest * Ndataset], can be a full matrix NxN
%    What  = estimated affinities


Ntest = size(Xtest,1);
Ntrain = size(Xtraining,1);


% divide test set in chunks and process each chunk. The number of chunks is
% computed so that each similarity matrix does not has more than one
% million entries.
Nchunks = max(1,ceil(Ntrain*Ntest/1000000));
chunks = fix(linspace(0, Ntest, min(Ntest, Nchunks)));

er=0;
for nc = 1:length(chunks)-1
    disp(sprintf('Chunk of data number %d out of %d', nc, Nchunks-1))
    m = chunks(nc)+1:chunks(nc+1);
    Wtrue = -distMat(Xtest(m,:), Xtraining);
    if isempty(SHparam) % all methods except MDSH
        What  = Utest(m,:)*Utraining';
    else
        What=hammingDistEfficientNew(Utest(m,:),Utraining,SHparam);
    end
    
    [sWtrue, Rtrue] = sort(Wtrue, 2, 'descend');
    [sWhat, Rhat] = sort(What, 2, 'descend');
    
    for t = 1:length(m)
        [tf, loc] = ismember(Rhat(t,:), Rtrue(t,:));
        er = er+loc;
    end
end
er = er/Ntest;

%er = mean(loc,1);



if nargout == 0 || nargin > 3
    if isempty(fig);
        fig = figure;
    end
    figure(fig)

    plot(er, varargin{:})
    xlabel('Ranking')
    ylabel('Expected rank')

    hold on
end