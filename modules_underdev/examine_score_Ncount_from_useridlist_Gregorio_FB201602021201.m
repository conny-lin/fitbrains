
% input variable
% userid_target


% paths
cd('/Users/connylin/Dropbox/fb/Database/FitBrainsTrainer_20140314/Matlab_Transformed')

%% load userid data
load FBT_scoreVal_userid;

%% get userid 

i = ismember(userid, userid_target);
n_scores = numel(i);
n_scores_target = sum(i);
pct_score_target = (n_scores_target/n_scores)*100;

%% report
fprintf('database has %d scores\n',n_scores);
fprintf('%d (%.1f%%) scores were from userid_target\n',...
    n_scores_target,...
    pct_score_target);
