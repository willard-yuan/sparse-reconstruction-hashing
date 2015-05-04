clear all;
clc;
addpath 'SRH' 'SH' 'CH' 'LSH' 'MDSH' 'USPLH' 'dataIO'
warning off;

dataset='./data/Data_cifar.mat';
%dataset='./data/Data_Tiny.mat';

c_num=1000;
epsilon=0.002;
USPLH_lambda=0.125;
USPLH_cnum=2000;

if(exist('Xtraining','var')==0)
    load(dataset, 'Xtraining');
end
if(exist('Xtest','var')==0)
    load(dataset, 'Xtest');
end
if(exist('KNN_info','var')==0)
    load(dataset, 'KNN_info');
end
% Xtest=Xtest(1:1000,:);

%set params 
loopbits=[32]; %or  [16 24 32 48];
param.block_size=1000;
param.searchtype='ranking'; % an alternative is "lookup"

%
%matfile='result_cifar10ranking.mat';
matfile='Data_Tinyranking.mat';
save(matfile,'loopbits');

% M_set=[10 50 100 200 300 400 500 700 1000 1500 2000];
i=0;
for var=loopbits
    i=i+1;
    fprintf('%d\n', var);
    param.nbits=var;
   %  our method SRH: sparse reconstruction hashing
   fprintf('\n ====== sparse reconstruction hashing ======= \n')
   SRHparam=param;
   SRHparam.doMask=0; % switch of indexing full OR part of dataset
   SRHparam.alpha=0.1; % alpha is a balance parater
   SRHparam.L=3; % the number of hash tables
   SRHparam.eta=0.1; % eta is a parater, see paper in detail
   SRHparam.c_num=c_num; % the number of supervised points (should be large for large dataset)
   SRHparam.epsilon=epsilon; % the threshold to find the points to be indexed in the next hash table
   SRH_info{i} =evaluate_SRH(Xtraining, Xtest, KNN_info, SRHparam);
   save(matfile, 'SRH_info', '-append');
   
    % CH nomask: complementary hashing without mask
    fprintf('\n ====== complementary hashing ======= \n')
    CHparam=param;
    CHparam.doMask=1;
    CHparam.eta=0.1;
    CHparam.L=3;
    CHparam.c_num=c_num;
    CHparam.epsilon=epsilon;
    CH_mask_info{i} =evaluate_CH_ext(Xtraining, Xtest, KNN_info, CHparam);
    save(matfile, 'CH_mask_info', '-append');
   
    % USPLH: unsupervised sequential projection learning for hashing
    fprintf('\n ====== unsupervised sequential projection learning for hashing ======= \n')
    USPLHparam=param;
    USPLHparam.eta=1;
    USPLHparam.lambda=USPLH_lambda;
    USPLHparam.c_num=USPLH_cnum;
    USPLH_info{i} =evaluate_USPLH(Xtraining,Xtest,KNN_info,USPLHparam);
    save(matfile, 'USPLH_info', '-append');
    
    % SH: spectral hashing
    fprintf('\n ====== spectral hashing ======= \n')
    SHparam=param;
    SH_info{i} =evaluate_SH(Xtraining,Xtest,KNN_info,SHparam);
    save(matfile, 'SH_info', '-append');

    % LSH: local sensitive hashing
    fprintf('\n ====== local sensitive hashing ======= \n')
    LSHparam=param;
    LSHparam.L=3;
    LSH_info{i} =evaluate_LSH(Xtraining,Xtest,KNN_info,LSHparam);
    save(matfile, 'LSH_info', '-append');
    
    % MDSH: multidimention spetral hashing
    fprintf('\n ====== multidimention spetral hashing ======= \n')
    MDSHparam=param;
    MDSHparam.L=3;
    MDSH_info{i} =evaluate_MDSH(Xtraining,Xtest,KNN_info,MDSHparam);
    save(matfile, 'MDSH_info', '-append');
    
end

%% plot recall-the number of the returned samples curve.
%%% if searchtype adopts ranking, comment two lines in eva_ranking()
clearvars -except matfile;
load(matfile);
figure; hold on;grid on;box on;
plot(SRH_info{1, 1}.recall, 'r-', 'linewidth', 2);
plot(CH_mask_info{1, 1}.recall,'b-','linewidth',2);
plot(LSH_info{1, 1}.recall,'g-', 'linewidth', 2);
plot(SH_info{1, 1}.recall,'m-', 'linewidth',2);
plot(MDSH_info{1, 1}.recall, '-','color', [0.295 0 0.51], 'linewidth', 2);
plot(USPLH_info{1, 1}.recall ,'k-', 'linewidth', 2);
xlabel('The number of the returned samples');
ylabel('Recall');
legend('Our Method', 'CH', 'LSH','SH','MDSH','USPLH','Location','SouthEast');
axis square;

%% plot recall  precision curve.
% clearvars -except matfile;
% load(matfile);
% figure; hold on;grid on;box on;
% plot(SRH_info{1, 1}.recall, SRH_info{1, 1}.precision, 'r-+','linewidth', 2);
% plot(CH_mask_info{1, 1}.recall, CH_mask_info{1, 1}.precision,'b-^','linewidth', 2);
% plot(LSH_info{1, 1}.recall, LSH_info{1, 1}.precision,'g-p','linewidth', 2);
% plot(SH_info{1, 1}.recall,SH_info{1, 1}.precision,'m-d','linewidth', 2);
% plot(MDSH_info{1, 1}.recall, MDSH_info{1, 1}.precision,'-*','color', [75 0 130]/255,'linewidth', 2);
% plot(USPLH_info{1, 1}.recall, USPLH_info{1, 1}.precision,'k-h','linewidth', 2);
% axis([0 1 0 0.5]);
% xlabel('Recall');
% ylabel('Precision');
% legend( 'Our Method', 'CH', 'LSH', 'SH', 'MDSH','USPLH', 'Location', 'NorthEast');
% axis square;