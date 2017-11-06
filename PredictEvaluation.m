clc
clear
feat_dir = 'E:\12_CV_Research\hospital_pain\data\Person_Data\';
out_dir = 'E:\12_CV_Research\hospital_pain\Results\';

addpath D:\Program Files\MATLAB\MATLAB Production Server\R2015a\toolbox\libsvm-3.21\matlab
%addpath ..\matlab-implement[by faruto]\


load([feat_dir '\' 'PersonData_lbp.mat']);
data = person_feat;
label = person_label;

PNum = length(data);
tic
for i=1:PNum     

    test_data=[];
    test_label=[];
    
    test_data=data{i}; 
    test_label=label{i}; 

    train_data=[];
    train_label=[];

%%%---------Leave one person out -get the data-----%%%
    for m=1:i-1                      
       train_data=[train_data;data{m}]; 
       train_label=[train_label;label{m}];
    end
    
    for n=i+1:PNum                    
        train_data=[train_data;data{n}]; 
        train_label=[train_label;label{n}];
    end 
    
    sprintf('This is the_ "%d" iteration', i)
    
    
    %%%--------do regression------%%%
    model = svmtrain(train_label, train_data, '-s 3 -t 0 -c 10 -p 0.01');
    [predy, acc, dec] = svmpredict(train_label, train_data, model);
    mse_train = acc(2)
    rcoef_train = acc(3)
    
    [tstpredY, Acc, Dec]= svmpredict(test_label, test_data, model);
    mse_tst = Acc(2)
    rcoef_tst = Acc(3)
    
    PredY = [PredY; tstpredY];
    ACC = [ACC; Acc];
    DecValue = [DecValue; Dec];
    
    mse = CalcMSE(tstpredY, test_label);
    pcc = CalcPCC(tstpredY, test_label);
    
    
    MSE = [MSE; mse];
    PCC = [PCC; pcc];
end

MeanMSE = mean(MSE);
MeanPCC = mean(PCC);
