function DV = load_legend_score(gameid,varargin)


% defaults
pLegend = '/Users/connylin/Dropbox/Code/Matlab/Library FB/Modules/2-Extraction Cleaning Annotation';

% varargin processor
if nargin>1
    vararginProcessor
end
% load game
cd(pLegend); a = load('dv_FBT_game','dv_FBT_game'); a = a.dv_FBT_game;


% keep only game of interest
if nargin>0
    a(~ismember(a.game_id,gameid),:) = []; 
end

% create output
DV = a;