%% FB201412161235
%
%% country id > region id
pData = '/Users/connylin/OneDrive/FB Database/FitBrainsTrainer_20140314_Matlab';
cd(pData);
load('Trainer_global_regions.mat','Trainerglobalregions');
load('Trainer_mobile_device_regions.mat','Trainermobiledeviceregions');

[i,j] = ismember(Trainermobiledeviceregions.region_id,Trainerglobalregions.id);
a = Trainerglobalregions.country_id(j);
b = Trainerglobalregions.id(j);
if Trainermobiledeviceregions.region_id == b
    display 'region id:country id matching validated'
end
A.device_id = Trainermobiledeviceregions.device_id;
A.country_id = a;
clear Trainerglobalregions
clear Trainermobiledeviceregions;

%% region id  device id
pData = '/Users/connylin/OneDrive/FB Database/FitBrainsTrainer_20140314_Matlab';
pSave = '/Users/connylin/OneDrive/FB analysis matlab/FB201412161235';
cd(pData);
load('Trainer_mobile_user_devices.mat','Trainermobileuserdevices');
[i,j] = ismember(Trainermobileuserdevices.device_id,A.device_id);
k = find(j ~= 0);
a = zeros(numel(i),1);
a(k) = A.country_id(j(k));
b = zeros(numel(i),1);
b(k) = A.device_id(j(k));
if Trainermobileuserdevices.device_id(k) == b(k)
    display 'country_id:device id:user_id matching validated'
end
clear A;
A.user_id = Trainermobileuserdevices.user_id;
A.country_id = a;
clear Trainermobileuserdevices

%% add to user info
load('Trainer_mobile_user_info_user_id');
[i,j] = ismember(Trainer_mobile_user_info_user_id,A.user_id);
k = find(j ~= 0);
a = zeros(numel(i),1);
a(k) = A.country_id(j(k));
b = zeros(numel(i),1);
b(k) = A.user_id(j(k));
if Trainer_mobile_user_info_user_id(k) == b(k)
    display 'country_id:user_id matching validated'
end
clear A;
A = table;
A.user_id = Trainer_mobile_user_info_user_id;
A.country_id = a;
clear Trainer_mobile_user_info_user_id

%% add age
str = 'Trainer_mobile_user_info_age';
D = load(str); D = D.(str); 
A.age = D;
str = 'Trainer_mobile_user_info_education';
D = load(str); D = D.(str); 
A.education = D;

%% clean memory
clearvars -except A;

%% do stats and convert using legends 

%% how mnany users per country?
B = tabulate(A.country_id);

% load country code
pData = '/Users/connylin/OneDrive/FB Database/FitBrainsTrainer_20140314_Matlab';
cd(pData);
load('Trainer_global_countries.mat','Trainerglobalcountries');
[i,j] = ismember(B(:,1),Trainerglobalcountries.id);
k = find(j ~= 0);
a = cell(numel(i),1);
a(k) = Trainerglobalcountries.code(j(k));
a = regexprep(a,'"','');
a(:,2:3) = num2cell(B(:,2:3));
% b(k) = A.device_id(j(k));
T = array2table(a,'VariableNames',{'country','N','percent'});
cd(pSave);
writetable(T,'countryN','Delimiter','\t');


%% total number of registered users
str = 'total number of registered users = %d';
display(sprintf(str,size(A,1)))

%% age distribution (5 increments)
% how many with known age
str = 'total number of registered users with known age = %d';
a = sum(~isnan(A.age));
display(sprintf(str,a));

str = 'total number of users with known age and location =  %d';
a = sum(~isnan(A.age) & A.country_id >0);
display(sprintf(str,a));

str = 'total number of users within known age in US and Canada = %d';
canada = 1; us  = 3;
a = sum(~isnan(A.age) & A.country_id ==canada) + ...
     sum(~isnan(A.age) & A.country_id ==us);
display(sprintf(str,a));

%% age distribution of users in US
B = A(A.country_id == us,:);
cd(pSave);
writetable(...
        array2table(tabulate(B.age),...
        'VariableNames',{'age','N','percent'}),...
        'ageN_US','Delimiter','\t')





















