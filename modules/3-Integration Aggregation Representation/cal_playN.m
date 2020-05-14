function T = cal_playN(user_id)
%% count number of user_id occurance
a = tabulate(user_id);
a(:,3) = [];
a(a(:,2)==0,:) =[];
n = a(:,2);
%% count play N
a = tabulate(n);
a(:,3) = [];
a(a(:,2)==0,:) =[];
%% export to table
T = table;
T.playN = a(:,1);
T.userN = a(:,2);