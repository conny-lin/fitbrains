%% find last score id from current matlab database

%% path
pData = '/Users/connylin/Dropbox/fb/Database/FitBrainsTrainer_20140314/Matlab_Transformed';

cd(pData);
load FBT_scoreVal_scoreid

%%
scoreid = max(scoreid);

%%
fprintf('max score id downloaded = %d\n',scoreid)


