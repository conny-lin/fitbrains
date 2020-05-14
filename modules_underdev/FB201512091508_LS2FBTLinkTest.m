%% FUNCTION PATHS
% general home path
pMatFun = '/Users/connylin/Dropbox/Code/Matlab';
% add packges
addpath([pMatFun,'/General']);


%% 
pSave = '/Users/connylin/Dropbox/fb/Publication InPrep/Manuscript Lifestyle and Cognitive Abilities/Data/Factor analysis';
addpath('/Users/connylin/Dropbox/fb/Publication InPrep/Manuscript Lifestyle and Cognitive Abilities/Materials and Methods/Link FBT and LS');
A = linkLS2FBT('pSave',pSave);