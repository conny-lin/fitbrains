%% find SQL fields needed for download
pData = '/Users/connylin/Dropbox/fb/Database/FitBrainsTrainer_20140314/SQL_Import';

addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');

%% 
fn = dircontent(pData);

fn = regexprep(fn,'[.]csv','');
fn = regexprep(fn,'[.]txt','');
fn = regexprep(fn,'[.]zip','');
fn(ismember(fn,'.git')) = [];

fnf = regexpcellout(fn,'_','split');
fnf(:,5:end) = [];
fn = regexprep(fn,'_','.');
char(fn)

%% get last userid
pData = '/Users/connylin/Dropbox/fb/Database/FitBrainsTrainer_20140314/Matlab_Transformed';

load FBT_userinfo_userid

userid(end)