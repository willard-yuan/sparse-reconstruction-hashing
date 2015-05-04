function genSIFT()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAND TOY 
Ntraining = 10000; % number training samples
Ntest = 500; % number test samples
% Nvad = 400;
Dim=60;
Nneighbors = 0.02*Ntraining; % number of groundtruth neighbors on training set (average)

% uniform distribution
SIFT_trndata = single(rand([Ntraining,Dim]));
SIFT_tstdata = single(rand([Ntest,Dim]));
% SIFT_vaddata = single(rand([Nvad,Dim]));

MM=mean(SIFT_trndata, 1);
SIFT_trndata=SIFT_trndata-repmat(MM,Ntraining,1);
SIFT_tstdata=SIFT_tstdata-repmat(MM,Ntest,1);

figure;
scatter(SIFT_trndata(:,1), SIFT_trndata(:,2), 3, 'b');
hold on;
scatter(SIFT_tstdata(:,1), SIFT_tstdata(:,2), 3, 'r');

% define ground-truth neighbors (this is only used for the evaluation):
DtrueTestTraining = distMat(SIFT_tstdata,SIFT_trndata); % size = [Ntest x Ntraining]
[Dball, I] = sort(DtrueTestTraining,2); %∞¥––≈≈¡–
KNN_info.knn_p2=I(:,1:Nneighbors);
KNN_info.dis_p2=Dball(:,1:Nneighbors);

% save Data_Rand60D SIFT_trndata SIFT_tstdata SIFT_vaddata KNN_info;
Xtraining=SIFT_trndata;
Xtest=SIFT_tstdata;
save('.\data\Data_Rand60D.mat','Xtraining','Xtest','KNN_info');
