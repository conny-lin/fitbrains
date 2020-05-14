function Data = load_score_emotion201602(varargin)

%% defaults
pFBTD = '/Users/connylin/Dropbox/fb/Database/Emotion_20160224/Matlab/user_scores_eq_only.mat';
iv = Inf; %{'score','RT','accuracy'};
gameid = Inf;
exclude = {};
user_id = [];

%% varargin processing
vararginProcessor;


%% load data: emotion
D = load(pFBTD); 
Data = D.EQscore; 
clear D; 
%% replace variable names with simplified names
Data.Properties.VariableNames(ismember(Data.Properties.VariableNames,'reaction_time')) = {'RT'};

%% standard cleaning
% clean out gameid=nan
Data(isnan(Data.game_id),:) = [];
% exclusion criteria -----------------------------------------------------
% game 35 exclusion criteria: exclude RT=60|0
Data((Data.RT>=15 | Data.RT==0) & Data.game_id==35,:) = [];
% game 36 exclusion criteria: none
% game 37 exclusion criteria: exclude RT>=5|0
Data((Data.RT>=5 | Data.RT==0) & Data.game_id==37,:) = [];
% game 38 exclusion criteria: none
% ------------------------------------------------------------------------


%% process requested exclusions
% gameid processing
if ~isinf(gameid)
   Data(~ismember(Data.game_id,gameid),:) = [];
end

%% get speific user_id
if ~isempty(user_id)
   Data(~ismember(Data.user_id,user_id),:) = [];
end

%% iv specific processing
if ~isinf(iv); 
   for ivi = 1:numel(iv)
       switch iv{ivi}
           case 'N'
               Data.N = Data.RT.\60;
       end
   end
   % remove unrquested iv
   Data(:,~ismember(Data.Properties.VariableNames,iv)) = [];
end

%% exclude list
if ~isempty(exclude)
   Data(:,ismember(Data.Properties.VariableNames,exclude)) = [];
end















   




