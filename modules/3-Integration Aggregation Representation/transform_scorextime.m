function S = transform_scorextime(Data,varargin)

%%
testN = 30;
includeNaN = true;
msr = 'score';
%%
vararginProcessor;

%% sort times
D = [Data.user_id Data.played_at_utc Data.id];
D = sortrows(D,[1 2]);
[iStart,iFinish,playN,userid] = find_userboundry(D(:,1));

%% make matrix
A = [iStart iFinish playN userid];

if ~includeNaN
    A(A(:,3)<testN,:) = [];
end

%%
S = nan(size(A,1),testN);
userid = A(:,4);
for si = 1:testN
    r1 = A(:,1);
    scoreid = D(r1,3);
    [i,j] = ismember(scoreid,Data.id);
    s = Data.(msr)(j(i));
    u = Data.user_id(j(i));
    % match with score id
    [k,l] = ismember(userid,u);
    S(k,si) = s(l(k));
    % cut off user id that does not have more scores
    A(A(:,3)==si,:) = [];
    % increase starting number
    A(:,1) = A(:,1)+1;
    
end

