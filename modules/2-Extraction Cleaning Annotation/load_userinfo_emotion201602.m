function [U,IV,Legends] = load_userinfo_emotion201602(varargin)

%% path default
pUserdata = '/Users/connylin/Dropbox/fb/Database/Emotion_20160224/Matlab/Userinfo.mat';
pLegend = '/Users/connylin/Dropbox/Code/Matlab/Library FB/Modules/2-Extraction Cleaning Annotation';
iv = {'user_id','agegroup','gender','education'};
excludeNaN = true;
textvar = false;

%% varargin processor
vararginProcessor


%% load preferred IV list legend
Legends = struct;
cd(pLegend);
for ivi =1:numel(iv)
    switch iv{ivi}
        case 'agegroup'
            % age
            a = load('legend_age.mat','legend_agegroup1015');
            a = a.legend_agegroup1015;
            if excludeNaN; a(isnan(a.id),:) = [];end
            agegroupu = a.id;
            IV.agegroup = agegroupu;
            Legends.agegroup = a;
        case 'gender'
            % gender
            a = load('legend_gender.mat','legend_gender_binary');
            a = a.legend_gender_binary;
            genderu = a.id;
            IV.gender = genderu;
            if excludeNaN; a(isnan(a.id),:) = [];end
            Legends.gender = a;
        case 'education'
            % education
            a = load('legend_education.mat','legend_education_table');
            a = a.legend_education_table;
            if excludeNaN; a(isnan(a.id),:) = [];end
            eduu = a.id;
            IV.education = eduu;
            Legends.education = a;
    end
end



%% load user data 
U = load(pUserdata,'Userinfo'); U = U.Userinfo;
% iv specific processing
for ivi =1:numel(iv)
    switch iv{ivi}
        case 'agegroup'
            % transform user IV values 
            agegroup = convertAge2AgeGroup_5yr10yr(U.age);
            U.agegroup = agegroup;
            U.age =[];
            % remove user data that's not valid for analysis
            U(~ismember(U.agegroup,Legends.agegroup.id),:) =[];
            if excludeNaN
               U(isnan(U.agegroup),:) = [];
            end
        case 'gender'
            % gender
            U.gender(U.gender==2)=0; % convert 2 to 0
            if excludeNaN
               U(isnan(U.gender),:) = [];
            end
    end
end
U = U(:,iv); % only include requested iv




%% translate user factors into text
if textvar
    for ivi = 1:numel(iv)
        U.(iv{ivi}) = translate_legend(Legends.(iv{ivi}).id, Legends.(iv{ivi}).abv, U.(iv{ivi}));
    end
end











