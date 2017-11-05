clc
clear

feat_dir = 'E:\12_CV_Research\hospital_pain\LBP_features\';
label_dir = 'E:\12_CV_Research\hospital_pain\data\format_label\';
out_dir = 'E:\12_CV_Research\hospital_pain\data\Person_Data\';

mkdir(out_dir);

users = dir(feat_dir);
users = {users(3:end).name};


%%-------save the instance----------------------%%%%%%
for fol = 1:length(users)
    [feat, frmLabel] = deal([]);
    viddir = fullfile(feat_dir, users{fol});
    load(fullfile(viddir, 'lbptop_p8_r1.mat'));
    feat = ux';
    
    labeldir = fullfile(label_dir, users{fol})
    vid_label = dir(fullfile(labeldir, '*.mat'));
    vid_label = vid_label.name;    
    load(fullfile(labeldir, vid_label));
    vidname = VidndScore(:,1);
    label = VidndScore(:,2); 
    vidLabel = cell2mat(label);
 
    size(feat,1)
    size(vidLabel,1)
    if size(feat,1) == size(vidLabel,1)
        person_feat{fol} = feat;
        person_label{fol} = vidLabel;
    else
        sprintf('"%s" length of features doesnot equal to length of vidlabels', users{fol})
    end
end
save([out_dir 'PersonData_LBPTOP'],'person_feat', 'person_label')
%%---------save the label-----------------------%%%%%%
