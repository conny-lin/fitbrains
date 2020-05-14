function [DataOut,gu,iv,dv] = FBTscore_getIVDV(Data,varargin)

%% post processing of fBT scores
% - extract from data import the iv and dv needed
% - change reaction_time to RT
% - must have game_id to select game_id

%% ------------------ PRE-PROCESSING  -------------------------------------
% replace reaction_time with "RT"
vn = Data.Properties.VariableNames;
Data.Properties.VariableNames(ismember(vn,'reaction_time')) = {'RT'};
% add test N calculated from reaction_time
Data.N = Data.RT.\60;

%% ------------------ DEFAULT  -------------------------------------------- 
iv = {'user_id','game_id','userid','gameid','id','played_at_utc'};
fn = Data.Properties.VariableNames;
iv(~ismember(iv,fn)) = [];
dv = fn(~ismember(fn,iv)); % default to keep all dv
gu = unique(Data.game_id); % select all game ids
gameid = gu;
keepIV = true;
% varargout = {};
%% ----------------- VARARGIN PROCESSING  --------------------------------- 
vararginProcessor
%% ----------------- POST VARARGIN PROCESSING  ---------------------------- 
% deal with inputs reaction_time/RT
dv(ismember(dv,'reaction_time')) = {'RT'};
%% ----------------- CODE -------------------------------------------------

% keep IV or not
if keepIV 
   dvkeep = [iv dv];
else
   dvkeep = dv;
end
% take out game of interest
if ~isequal(gu,gameid)
    if sum(ismember(fn,'game_id'))
        DataOut = Data(Data.game_id==gameid,dvkeep);
    elseif sum(ismember(fn,'gameid'))
        DataOut = Data(Data.gameid==gameid,dvkeep);
    else
        error('code this');
    end
else
    DataOut = Data(:,dvkeep);
end



