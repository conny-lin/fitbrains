function [UI,ANSV] = LS_get_ValidUserAndAnswerSet(User_Info,ANS,ANS_seq,AgeLimit,countryLimit)


% restrict ageLimit
if nargin >=4
    fprintf('restrict age %d-%d\n',AgeLimit(1), AgeLimit(2));
    i = User_Info.age < AgeLimit(1) | User_Info.age > AgeLimit(2);
    User_Info(i,:) = [];
end

% restrict country id limiit
if nargin >= 5
    fprintf('restrict country id \n');
    i = ~ismember(User_Info.country_id,countryLimit);
    User_Info(i,:) = [];
end

% get users 89 or younger
User_Info(User_Info.age >= 90,:) = [];

% get users with full demographic info
uval = getUsersWithFullDemographicInfo(User_Info);


% get answers
if ANS_seq == 1 % first answer
    ANSV = getFirstAnswersPerUser(ANS);
elseif ANS_seq == 0 % all answers
    ANSV = ANS;
end

% report N
n = size(ANSV,1);
fprintf('%d answers from unique users \n',n);


% get only users with full info
i = ~ismember(ANSV.user_id,uval);
ANSV(i,:) = [];
n = size(ANSV,1);
fprintf('%d answers from unique users with full demographic info (age, gender, education)\n',n);
% get only userinfo with full demo info and complete answers
UI = User_Info(ismember(User_Info.user_id,ANSV.user_id),:);


% age
str = 'Mean age of the sample is %.2f (s.d. %.2f)\n';
m = mean(UI.age);
s = std(UI.age);
fprintf(str,m,s); % display results
% gender
str = 'gender breakdown is %.1f%% male and %.1f%% female\n';
a = tabulate(UI.gender);
m = a(a(:,1)==1,3);
f = a(a(:,1)==0,3);
fprintf(str,m,f); % display results