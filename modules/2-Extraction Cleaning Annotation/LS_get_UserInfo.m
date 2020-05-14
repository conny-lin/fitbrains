function Userinfo = LS_get_UserInfo(dbhome)
% load userid link info
LS1 = load(sprintf('%s/LifeAssessment_20140314/Matlab/LA_master_20160111.mat',dbhome));
Userinfo = LS1.User_Info;
% combine LS demo info
load(sprintf('%s/LifeAssessment_20140314/Matlab/LA_master6.mat',dbhome));
LS.country_code(1,:) = [];
[i,j] = ismember(Userinfo.country_id,LS.country_code.country_id);
A = cell(size(LS.countryid));
A(i) = LS.country_code.country_code(j(i));
Userinfo.countrycode = A;
Userinfo.country_id = [];
clear A i j;