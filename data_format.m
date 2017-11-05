clc
clear

feat_dir = 'E:\12_CV_Research\hospital_pain\LBP_features_v2\';
label_dir = 'E:\12_CV_Research\hospital_pain\data\format_label\';
out_dir = 'E:\12_CV_Research\hospital_pain\data\Person_Data\';

mkdir(out_dir);

users = dir(feat_dir);
users = {users(3:end).name};


%%-------save the instance----------------------%%%%%%
for fol = 1:length(users)
    viddir = fullfile(feat_dir, users{fol});
    vids = dir(viddir);
    vids = {vids(3:end).name};
    labeldir = fullfile(label_dir, users{fol})
    vid_label = dir(fullfile(labeldir, '*.mat'));
    vid_label = vid_label.name;
    
    load(fullfile(labeldir, vid_label));
    vidname = VidndScore(:,1);
    label = VidndScore(:,2); label = cell2mat(label);
 
    [feat, frmLabel] = deal([]);
    for v = 1:length(vids)
        vidfeat_dir = fullfile(viddir, vids{v})
        %vidfeat = dir([vidfeat_dir, '\' '*.mat']);
        [tmp, tmpLabel] = deal([]);
        frm_dir = [vidfeat_dir '\' 'lbp_p8_r1.mat'];
        %cd(vidfeat_dir)
        load(frm_dir);  %%%!!!!! when load, vids-> 21
        tmp = ux';
        frmNo = size(tmp,1);
        feat = [feat; tmp];
        tmpLabel(1:frmNo) = label(v);
        tmpLabel = tmpLabel';
        frmLabel = [frmLabel; tmpLabel];
    end
    size(feat,1)
    size(frmLabel,1)
    if size(feat,1) == size(frmLabel,1)
        person_feat{fol} = feat;
        person_label{fol} = frmLabel;
    else
        sprintf('"%s" length of features doesnot equal to length of frmlabels', users{fol})
    end
end
save([out_dir 'PersonData_lbp'],'person_feat', 'person_label')
%%---------save the label-----------------------%%%%%%
