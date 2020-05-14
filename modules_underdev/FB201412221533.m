% FB201412221533
% try factor analysis to collapse subdomains into 3 supra domains

%% 1. DEFINE PATHS/GLOBAL VARIABLES
% OBJECITVE: Is there an improvement from Max-initial score of CogA
% updated: 20141107

% create global variable object:
Info = []; % declare object

% define project objective and output paths *******
Info.codeName = 'FB201412221533';
Info.path.pOutputHome = '/Users/connylin/OneDrive/FB analysis matlab';

% define output names
pO = [Info.path.pOutputHome,'/',Info.codeName,' Output'];
if isdir(pO) == 0; mkdir(pO); end

% add function paths *******
Info.path.pFun = '/Users/connylin/OneDrive/MATLAB/Functions_Developer';
addpath(Info.path.pFun);

% REPORT START
clc; display(sprintf('***** RUNNING %s *****',Info.codeName));


% SAMPLE PATHS
% load score
% define FB database path (pD)
test = 'Database home';
Path.pDatabase = '/Users/connylin/OneDrive/FB Database';
% define specific database
Proj.databasename = 'FitBrainsTrainer_20130925_Matlab';
Path.pD = [Path.pDatabase,'/',Proj.databasename];
filename = 'ScoreCleanwithID.mat';
cd(Path.pD); load(filename,'Score');


%% 