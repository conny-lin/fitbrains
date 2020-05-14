
% input variable
disorder_name = 'parkinsons';

% paths
cd('/Users/connylin/Dropbox/fb/Database/FitBrainsTrainer_20140314/Matlab_Transformed')
load FBT_userinfo_medcond.mat;

% get index
i = ismember(medcondL(:,2),disorder_name);
ind = medcondL{i,1};

%% get number of people with disorder_name
i = medcond == ind;
userid_disorder = unique(userid(i));

n_user_with_disorder = numel(userid_disorder);
n_user = numel(unique(userid));
pct_user_with_disorder = (n_user_with_disorder/n_user)*100;


%% reporting
fprintf('database has %d unique users\n',n_user);
fprintf('%d (%.1f%%) individuals has %s\n',...
    n_user_with_disorder,...
    pct_user_with_disorder,...
    disorder_name);


