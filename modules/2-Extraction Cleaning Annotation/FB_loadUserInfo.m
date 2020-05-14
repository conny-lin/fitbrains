function [T] = FB_loadUserInfo(dbpath,userid,varname)

% get userid index
cd(dbpath);
D = load(sprintf('%s','FBT_userinfo_userid.mat'));
i = ismember(D.userid,userid);
T = table;
T.userid = D.userid(i);
for vi = 1:numel(varname)
    vn = varname{vi};
    % get age
    D = load(sprintf('%s/FBT_userinfo_%s.mat',dbpath,vn));
    T.(vn) = D.(vn)(i);
end