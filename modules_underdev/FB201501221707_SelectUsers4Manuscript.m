%% OBJECTIVE: SELECT USERS
% criteria: No duplicated data (unique playtime, userid, score, game)

%% 0. Clear memory
% clear memory
clear; clc;

%% 1. DEFINE PATHS/GLOBAL VARIABLES
% create global variable object:
Info = []; % declare object

% define project objective and output paths *******
Info.Projcode = 'FB201501221707_SelectUsers4Manuscript';
Info.path.pOutputHome = '/Users/connylin/OneDrive/FB Analysis';

% define output names
pO = [Info.path.pOutputHome,'/',Info.Projcode];
if isdir(pO) == 0; mkdir(pO); end

% add function paths *******
Info.path.pFun = '/Users/connylin/OneDrive/MATLAB/Functions_Developer';
addpath(Info.path.pFun);

% REPORT START
clc; display(sprintf('***** RUNNING %s *****',Info.Projcode));



%% 2. GET GLOBAL INFOMRAITON
% this will need sequential procesing
% define path to database
pDatabase = '/Users/connylin/OneDrive/FB Database/';
pD = [pDatabase,'FitBrainsTrainer_20140314_Matlab_Transformed'];


%% LOAD USER INFO DATA
% load age
prefix = '/FBT_userinfo_';
varname = 'age';
filepath = [pD,prefix,varname,'.mat'];
M = matfile(filepath);

i = M.(varname) >= 65 & M.(varname) <= 80;
sum(i)


% get user id 
filepath = [pD,'/','FBT_userinfo_userid.mat'];
varname = 'userid';
A = load(filepath);
u = A.(varname)(i);
clear A i;

% look for score data
prefix = '/FBT_score_';
varname = 'userid';
M = matfile([pD,prefix,varname,'.mat']);
i = ismember(M.(varname)(:,2),u);
clear u M;

% get unique user id from score data (useridVal)
prefix = '/FBT_score_';
varname = 'userid';
A = load([pD,prefix,varname,'.mat']);
useridVal = unique(A.(varname)(i,2));
clear A i;

% go back to look at demographics of users who has score data
prefix = '/FBT_userinfo_';
varname = 'userid';
filepath = [pD,prefix,varname,'.mat'];
M = matfile(filepath);
i = ismember(M.(varname),useridVal);

% get gender, education, and age information 
A = [];

prefix = '/FBT_userinfo_'; varname = 'userid';
filepath = [pD,prefix,varname,'.mat'];
M = load(filepath);
A(:,1) = M.(varname)(i);

prefix = '/FBT_userinfo_'; varname = 'age';
filepath = [pD,prefix,varname,'.mat'];
M = load(filepath);
A(:,2) = M.(varname)(i);

prefix = '/FBT_userinfo_'; varname = 'education';
filepath = [pD,prefix,varname,'.mat'];
M = load(filepath);
A(:,3) = M.(varname)(i);

prefix = '/FBT_userinfo_'; varname = 'gender';
filepath = [pD,prefix,varname,'.mat'];
M = load(filepath);
A(:,4) = M.(varname)(i);


% produce summary table
[t,c,p,L] = crosstab(A(:,3),A(:,4));
% manually cut and paste results here into excel
% save
userInfoVal = A;
cd(pO); save('userInfo.mat','userInfoVal');
 cd(pO); save('userN_educationXgender.mat','t','c','p','L');
clear A


%% RETURN
return
%% EXAMINE SCORE INFORMATION
clearvars -except pD;
pSave = '/Users/connylin/OneDrive/FB analysis matlab/FB07-Manuscript';
cd(pSave); load UserProfile20150122Test

%% get score id and userid
prefix = '/FBT_score_'; varname = 'userid';
filepath = [pD,prefix,varname,'.mat'];
M = load(filepath);
i = ismember(M.(varname)(:,2),userProfile(:,1));
A = M.(varname)(i,:);
clear M;

%% get score
prefix = '/FBT_score_'; varname = 'gameid';
filepath = [pD,prefix,varname,'.mat'];
M = load(filepath);
A(:,3) = M.(varname)(i,2);
%% get play time
prefix = '/FBT_score_'; varname = 'playtime';
filepath = [pD,prefix,varname,'.mat'];
M = load(filepath);
A(:,4) = M.(varname)(i,2);

%% get score
prefix = '/FBT_score_'; varname = 'score';
filepath = [pD,prefix,varname,'.mat'];
M = load(filepath);
A(:,5) = M.(varname)(i,2);


%% 
[~,i,~] = unique(A,'rows');
%%
sprintf('%0.0f',sum(i))

















