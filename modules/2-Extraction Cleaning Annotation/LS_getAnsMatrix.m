function [A] = LS_getAnsMatrix(ANS,varargin)


%%
userid = {};
iv = {};
vararginProcessor
%%
fn = ANS.Properties.VariableNames;
fnq = fn(regexpcellout(fn','q'));
if ~isempty(userid)
    [i,j] = ismember(userid, ANS.user_id);
    nrow = numel(userid);
    A = nan(nrow,numel(fnq));
    A(i,:) = table2array(ANS(j(i),fnq));
else
    A = table2array(ANS(:,fnq));
end

