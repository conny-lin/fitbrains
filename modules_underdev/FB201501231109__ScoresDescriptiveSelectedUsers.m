%% OBJECTIVE: SELECT USERS
% criteria: No duplicated data (unique playtime, userid, score, game)

%% 0. Clear memory
% clear memory
clear; clc;

%% 1. DEFINE PATHS/GLOBAL VARIABLES
% create global variable object:
Info = []; % declare object

% define project objective and output paths *******
Info.Projcode = 'FB201501231109__ScoresDescriptiveSelectedUsers';
pOutputHome = '/Users/connylin/OneDrive/FB Analysis';

% define output names
pO = [pOutputHome,'/',Info.Projcode];
if isdir(pO) == 0; mkdir(pO); end

% add function paths *******
Info.path.pFun = '/Users/connylin/OneDrive/MATLAB/Functions_Developer';
addpath(Info.path.pFun);

% REPORT START
clc; display(sprintf('***** RUNNING %s *****',Info.Projcode));



%% 2. GET GLOBAL INFOMRAITON
% this will need sequential procesing
% define path to database
pD = ['/Users/connylin/OneDrive/FB Database','/',...
    'FitBrainsTrainer_20140314_Matlab_Transformed'];
% userVAl data source:
pD_userVal = [pOutputHome,'/',...
    'FB201501221707_SelectUsers4Manuscript','/','userInfo.mat'];




%% EXAMINE SCORE INFORMATION

% load valid user info
load(pD_userVal,'userInfoVal');
userIDVal = userInfoVal(:,1); clear userInfoVal

% get score id and userid
% load files
prefix = '/FBT_score_'; varname = 'userid';
filepath = [pD,prefix,varname,'.mat']; M = load(filepath);
% calculations
userid = M.(varname)(ismember(M.(varname)(:,2),userIDVal),:); clear M;
cd(pO); save('userid.mat','userid'); 

% store score id
scoreid = userid(:,1); clear userid
cd(pO); save('scoreid.mat','scoreid');

% get game id
prefix = '/FBT_score_'; varname = 'gameid';
filepath = [pD,prefix,varname,'.mat']; M = load(filepath);
gameid = M.(varname)(ismember(M.(varname)(:,1),scoreid),1:2); clear M
cd(pO); save([varname,'.mat'],varname); clear scoreid


%% get g range



%% get index to each game id
cd(pO); load('gameid.mat','gameid');
% get gameidList
gameidList = unique(gameid(:,2))';

for g = gameidList
    index = gameid(:,2) == g;
    cd(pO); save(['index_game',num2str(g),'.mat'],'index');
end
clear gameid


%% get how many players play first session

% get play time by game
cd(pO); load('playtime.mat'); P = playtime; clear playtime;
% for every game
for g = gameidList

    filename = ['index_game',num2str(g),'.mat'];
    cd(pO); M = load(filename);
    playtime = P(M.index,1);
    cd(pO); save(['playtime_game',num2str(g),'.mat'],'playtime');
end
clear playtime index M P;


%% get userid time by game

cd(pO); load('userid.mat'); P = userid; clear userid;

% for every game
for g = gameidList

    filename = ['index_game',num2str(g),'.mat'];
    cd(pO); M = load(filename);
    userid = P(M.index,2);
    cd(pO); save(['userid_game',num2str(g),'.mat'],'userid');
end
clear userid index M P;
display 'done'

%% get scoreid  by game
cd(pO); load('scoreid.mat'); P = scoreid; clear scoreid;
% for every game
for g = gameidList

    filename = ['index_game',num2str(g),'.mat'];
    cd(pO); M = load(filename);
    scoreid = P(M.index,1);
    cd(pO); save(['scoreid_game',num2str(g),'.mat'],'scoreid');
end
clear scoreid index M P;
display 'done'


%% get rid of duplicated entries

%% START HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%% simplify play time before combining with user id
Report = [];

for g = gameidList

    cd(pO); load(['playtime_game',num2str(g),'.mat'],'playtime');
    cd(pO); load(['userid_game',num2str(g),'.mat'],'userid');
    A = [userid playtime]; clear userid playtime
    % there is something like 2013 in the playtime entry! should remove
    A = sortrows(A,[1,2]);

    % tabulate userid
    A = A(:,1);
    A = tabulate(A);
    A = A(A(:,2)>0,:); % get only user id with count
    A = sortrows(A,2); % sort counts
    % tabulate counts
    A = tabulate(A(:,2));
    % put in report
    Report(1:size(A,1),g) = A(:,2);
    
end

%% 
cd(pO); save('playcount.mat','Report');



