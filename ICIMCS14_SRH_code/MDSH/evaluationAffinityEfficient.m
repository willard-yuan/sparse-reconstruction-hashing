function [score, recall,mean_precision,true_nn,ham_nn] = evaluationAffinityEfficient(Xtraining, Xtest, Utraining, Utest, SHparam, T, fig, varargin)

%
% Input:
%    Wtrue = true neighbors [Ntest * Ndataset], can be a full matrix NxN
%    What  = estimated affinities
%   The next inputs are optional:
%    fig = figure handle
%    options = just like in the plot command
%
% Output:
%
%               exp. # of good pairs inside hamming ball of radius <= (n-1)
%  score(n) = --------------------------------------------------------------
%               exp. # of total pairs inside hamming ball of radius <= (n-1)
%
%               exp. # of good pairs inside hamming ball of radius <= (n-1)
%  recall(n) = --------------------------------------------------------------
%                          exp. # of total good pairs


% just get a feel for distances using 1000^2 comparisons
ntrain=size(Xtraining,1);
I=randperm(ntrain);
if (length(I)>1000)
    I=I(1:1000);
end

if isempty(SHparam) % all methods except MDSH
    What  = Utraining(I,:)*Utraining(I,:)';
else
    What=hammingDistEfficientNew(Utraining(I,:),Utraining(I,:),SHparam);
end

B=unique(What(:));
if (length(B)>200)
    maxAffinity=max(What(:));
    minAffinity=min(What(:));
    nn=1:200;
    B=minAffinity+(maxAffinity-minAffinity)*(1-nn/200);
end




Ntest = size(Xtest,1);
Ntrain = size(Xtraining,1);
Nbits = size(Utest,2);

total_good_pairs = 0;
retrieved_good_pairs = zeros(length(B),1);
retrieved_pairs = zeros(length(B),1);

NN = 20; %% num of NN to plot
true_nn = cell(1,2);
true_nn{1} = zeros(Ntest,NN);
true_nn{2} = zeros(Ntest,NN);

ham_nn = cell(1,2);
ham_nn{1} = zeros(Ntest,NN);
ham_nn{2} = zeros(Ntest,NN);

% divide test set in chunks and process each chunk. The number of chunks is
% computed so that each similarity matrix does not has more than one
% million entries.
Nchunks = max(1,ceil(Ntrain*Ntest/1000000));
chunks = fix(linspace(0, Ntest, min(Ntest, Nchunks)));
if (chunks(1)~=0), chunks = [0,chunks]; end

for nc = 1:length(chunks)-1
    disp(sprintf('Chunk of data number %d out of %d', nc, Nchunks-1))
    m = chunks(nc)+1:chunks(nc+1);
    
    Atrue = distMat(Xtest(m,:), Xtraining);
    Wtrue = (Atrue<T);
    [tmp,true_ind] = sort(Atrue,2);
    true_nn{1}(m,:) = true_ind(:,1:NN);
    true_nn{2}(m,:) = tmp(:,1:NN);
    Wtrue = Wtrue(:); 

    total_good_pairs = total_good_pairs + sum(Wtrue);
    
    if isempty(SHparam) % all methods except MDSH
        What  = Utest(m,:)*Utraining';
        [tmp,ham_ind] = sort(-(What),2);
        ham_nn{1}(m,:) = ham_ind(:,1:NN);
        ham_nn{2}(m,:) = (Nbits+tmp(:,1:NN))/2; %% hamming
                                                         %distance in bits
     
    else
        What=hammingDistEfficientNew(Utest(m,:),Utraining,SHparam);
        [tmp,ham_ind] = sort(-(What),2);
        ham_nn{1}(m,:) = ham_ind(:,1:NN);
        ham_nn{2}(m,:) = hammingDistEfficientNew(ones(1,Nbits),ones(1,Nbits),SHparam)+tmp(:,1:NN); %%% not sure how to parse
    end
    
    What = What(:);
    for n = length(B):-1:1
        j = (What>=B(n));
        retrieved_pairs(n) = retrieved_pairs(n) + sum(j);
        retrieved_good_pairs(n) = retrieved_good_pairs(n) + sum(Wtrue(j));
        %retrieved_good_pairs(n) = retrieved_good_pairs(n) + Wtrue*j';
    end
end
score = retrieved_good_pairs./retrieved_pairs;
recall= retrieved_good_pairs./total_good_pairs;

%%% now compute mean precision

% sort order of points...
[recall,ind] = sort(recall);
score = score(ind);

% draw horizontal line to recall=0 axis
if (recall(1)~=0)
  score2 = [ score(1) ; score ];
  recall2 = [ 0 ; recall ];
  % integrate
  mean_precision = trapz(recall2,score2);
else
  mean_precision = trapz(recall,score);
end

% The standard measures for IR are recall and precision. Assuming that:
%
%    * RET is the set of all items the system has retrieved for a specific inquiry;
%    * REL is the set of relevant items for a specific inquiry;
%    * RETREL is the set of the retrieved relevant items
%
% then precision and recall measures are obtained as follows:
%
%    precision = RETREL / RET
%    recall = RETREL / REL

threeplots=0;
if nargout == 0 || nargin > 3
    if isempty(fig);
        fig = figure;
    end
    figure(fig)
    if (threeplots)
        subplot(311)
        plot(0:length(score)-1, score, varargin{:})
        hold on
        xlabel('hamming radius')
        ylabel('percent correct (precision)')
        title('percentage of good neighbors inside the hamm ball')
        subplot(312)
        % plot(recall, score, varargin{:})
        plot(0:length(score)-1, recall, varargin{:})
        hold on
        axis([0 1 0 1])
        %xlabel('recall')
        %ylabel('percent correct (precision)')
        xlabel('hamming radius')
        ylabel('recall')
        drawnow
        subplot(313);
    end
    plot(recall, score, varargin{:})
    
    hold on
    axis([0 1.01 0 1.01])
    xlabel('recall')
    ylabel('percent correct (precision)')
    drawnow
end
