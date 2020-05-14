function FBTLS = FB201511021616_link_LStoFBT
%% link lifestyle with FBT

%% Pathswho
% create output path
pSave = mfilename('fullpath'); if isdir(pSave) == 0; mkdir(pSave); end
% function paths
addpath('/Users/connylin/Dropbox/MATLAB/Function_Library_Public');


%% lifestyle: 
LS = load('/Users/connylin/Dropbox/FB/Database/LifeAssessment_20140314/Matlab/LA_master5.mat');
a = table;
a.userid = LS.userinfo_userid;
a.email = LS.userinfo_email;
LS = a;
% remove duplicated emails
a = tabulate(LS.email);
a(cell2mat(a(:,2)) <= 1,:) = [];
LS(ismember(LS.email,a(:,1)),:) = [];

%% FBT
a = load('/Users/connylin/Dropbox/FB/Database/FitBrainsTrainer_20140314/Matlab/Trainer_mobile_emails.mat');
a = a.Trainer_mobile_emails;
% make sure all email id is unique
b = tabulate(a.id);
b(b(:,2) > 1 | b(:,2) == 0,:) = [];
a(~ismember(a.id,b(:,1)),:) = [];
a.email_id = a.id;
a.id = [];
a.status = [];
% link FBT email and userid
FBT = load('/Users/connylin/Dropbox/FB/Database/FitBrainsTrainer_20140314/Matlab/Trainer_mobile_user_emails.mat');
FBT = FBT.Trainer_mobile_user_emails;
FBT = innerjoin(FBT,a);
FBT.email_id = [];

%% link LS and FBT
LS.userid_LS = LS.userid;
LS.userid = [];
FBTLS = innerjoin(FBT,LS);
FBTLS.email = [];







