function [iStart,iFinish,playN,userid] = find_userboundry(a)
%% find boundry of a list of repetive numbers

%%
ind = [1;diff(a)] ~= 0; % ind to boundry row number
iStart = find(ind); % boundry row number
userid = a(ind); % index to data
playN = diff([iStart;numel(a)+1]);  % count of each type
iFinish = [iStart(2:end)-1;size(a,1)]; % finish index


