function id = switch_userid(id,idref_old,idref_new)

%% id old and id new must be aligned and same side

% change user id to FBT userid
% A = U.LS_score;
[i,j] = ismember(id,idref_old);
id(i) = idref_new(j(i));