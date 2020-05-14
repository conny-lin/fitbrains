%% PATH
paths = PathCommonList('ConnyCerebralCortex','FitBrains');
Objective = 'SQL019_Connect Trainer and Cog Assessment';
% data and save paths
pS = [paths.pS,'/',Objective];
pD = paths.pD;



%%
Trainer_user_user_scores_importfunction(dataname)


%% Initialize variables.
databasename = 'FitBrainsTrainer_20140314';
pDD = [pD,'/',databasename];

dircontent

%%
filename = [pDD,'/',dataname,'.txt'];
delimiter = '\t';
startRow = 2;
varfield = 'score';

formatSpec = '%f%*f%*f%*f%f%*s%*s%*s%*s%*[^\n\r]';
fileID = fopen(filename,'r');

A = textscan(fileID, formatSpec,...
    'Delimiter', delimiter,...
    'HeaderLines' ,startRow-1,...
    'ReturnOnError', false);
eval([varfield,'=[A{1},A{2}];']);
cd(pDD); save([dataname,'_',varfield,'.mat'],varfield);
fclose(fileID); 
eval(['clear ',varfield]);