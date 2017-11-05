clc
clear
feat_dir = 'E:\12_CV_Research\hospital_pain\data\Person_Data\';
out_dir = 'E:\12_CV_Research\hospital_pain\Results\';

load([feat_dir '\' 'PersonData_lbp.mat']);
data = person_feat;
label = person_label;

PNum = length(data);

temptrd = [];
tempd = [];
TrainAcc = [];
TestACC = [];
trueLabelFLPQBSIF =[];
predictlabel =[];

tic
for i=1:PNum     

    test_data=[];
    test_label=[];
    
    test_data=data{i}; 
    test_label=label{i}; 

    train_data=[];
    train_label=[];

    for m=1:i-1                      
       train_data=[train_data;data{m}]; 
       train_label=[train_label;label{m}];
    end
    
    for n=i+1:PNum                    
        train_data=[train_data;data{n}]; 
        train_label=[train_label;label{n}];
    end 
    
    sprintf('This is the_ "%d" iteration', i)

%%%---------Regression-----------%%%
    addpath('..\matlab-implement[by faruto]\');
    [BestMSE,Bestc,Bestg,Bestp,ga_option] = gaSVMcgpForRegress(train_label,train_data);
    cmd = [Bestc,Bestg,Bestp];

    %addpath E:\12_CV_Research\hospital_pain\code\liblinear-2.11\matlab
    model = svmtrain(train_label,train_data, '-s 3 -g 2.8 -p 0.01');
    [pred_y,mse,decv] = svmpredict(train_label,train_data,model);
    mse_train = mse(2);
    recoef_train = mse(3);
    
    figure;
    plot(train_data,train_label,'o');
    hold on;
    plot(train_data,pred_y,'r*');
    legend('????','????');
    grid on;


%     train_data = sparse(train_data);
%     test_data = sparse(test_data);
 
%   C=-6:2:16;  %参数寻优
%    d=0;
%    %addpath('D:\Program Files\MATLAB\MATLAB Production Server\R2015a\toolbox\libsvm-3.21\matlab');
% %    %addpath('toolboxes\liblinear-1.96\liblinear-1.96\matlab');
% %     for k=1:numel(C)
% %         model{k} = train(train_label,train_data, ...          
% %                 sprintf(' -c %f', 2^C(k)));  
% %                 
% %         [lbl, acc, dec] = predict(test_label, test_data, model{k});
% %         ACC(k) = acc(1);
% %     end 
% %     
% %     [idx1 idx2] = find(ACC == max(ACC));  
% %     bestc = C(idx2); 
% %     Model = model{idx2(1)}; 
%  
%     [lbltrain, acctrain, dectrain] = predict(train_label,train_data, Model); 
%     temptrd = [temptrd;dectrain];
%     TrainAcc = [TrainAcc;acctrain(1)];
%     
%     %Predict 
%     [lblM, accM, decM] = predict(test_label, test_data, Model);  
%     
%   
%     trueLabelFLPQBSIF = [trueLabelFLPQBSIF;test_label];                 
%     predictlabel = [predictlabel;lblM];
%     
%     tempd = [tempd;decM]; 
%     DecisionValueFLPQBSIF = tempd;
%     minbound = min(DecisionValueFLPQBSIF);
%     maxbound = max(DecisionValueFLPQBSIF);
%    TestACC= [TestACC;accM(1)];
% %% SVM网络训练
% %addpath('../libsvm-3.21/matlab');
% addpath D:\Program Files\MATLAB\R2014b\toolbox\libsvm-3.21\matlab
% [acc,c,g]=SVMcgForClass(train_label, P_train,-10,10,-10,10,3,2,1); %给出最佳的参数c,g,以及CV下的最佳准确率acc.
% model =svmtrain(train_label, P_train,'-c 12 -g 6');
% 
% %% SVM网络预测
% [ypred2, accuracy1, decision_values1] = svmpredict(test_label, P_test, model);
% axf(i)=accuracy1(1)
% i
end

%
save DecisionValueFLPQBSIF
save trueLabelFLPQBSIF

%% Reporting Results


acctrain = mean(TrainAcc);
MeanACC = mean(TestACC);
MaxAcc = max(TestACC);


%统计TP,FP，FN，TN
TP = 0;
FP = 0;
TN = 0;
FN = 0;
num_test = length(trueLabelFLPQBSIF);
pred_la = predictlabel;

class1 = find(trueLabelFLPQBSIF==1);
class0 = find(trueLabelFLPQBSIF==0);

P = length(class1);
Negative = length(class0);

for j = 1:num_test
    if pred_la(j)==1    
        if pred_la(j)==trueLabelFLPQBSIF(j)
            TP = TP+1;
        elseif pred_la(j)~=trueLabelFLPQBSIF(j)
            FP = FP+1;
        end 
    elseif pred_la(j)==0
        if pred_la(j)==trueLabelFLPQBSIF(j)
            TN = TN+1;
        elseif pred_la(j)~=trueLabelFLPQBSIF(j)
            FN = FN+1;
        end 
    end
end

hitRate = TP./P;
faRate = FP./Negative;
FAR = FP./(FP+TN);

Precision = TP./(TP+FP);
Recall = TP./(TP+FN);
F1 = (2*Precision*Recall)/(Precision+Recall);



WernerACC = (TP+TN)./(num_test);

F1pos = (2*TP)./(2*TP+FP+FN);
F1neg = (2*TN)./(2*TN+FP+FN);
macro_F1 = (F1pos+F1neg)./2;

SD1 = std(TestACC);
SD2 = std(TestACC, 1);

macro_F1


toc


%9:10-
%Elapsed time is 68928.510940 seconds.
%7.17 TBSIF： 12：55-
%7.20 Framelevel LBP:
