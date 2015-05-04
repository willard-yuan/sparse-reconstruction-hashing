load MNIST_gnd_release.mat;
clear MNIST_vaddata;
clear MNIST_vadlabel;
clear SR_M;

num_training = 30000;
Xtraining = MNIST_trndata(1:num_training,:);
clear MNIST_trndata;
Xtest = MNIST_tstdata;
clear MNIST_tstdata;

% Xtraining = Xtraining - repmat(datamean',num_training,1);
% Xtest = Xtest - repmat(datamean',1000,1);
Param.nbits = 8;
Param.c_num=2000;%%% %%% this parameter is for the number of pseduo pair-wise labels
USPLHparam.lambda=0.1;
USPLHparam.eta=0.125;
USPLHparam.w=0;
USPLHparam.b=0;
evaluate_USPLH(Xtraining,Xtest,1,Param)