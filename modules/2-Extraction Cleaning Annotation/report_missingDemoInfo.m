function [val,outputname,k] = report_missingvalues(Data,keyname,varargin)

%% report_missingDemoInfo(A)
% A must be table or struct

%% 
reportdir = 0;
% get field names
outputname = fieldnames(Data);
outputname(ismember(outputname,{'Properties',keyname})) = [];
vararginProcessor

%%
fieldnames(Data)
val = true(size(Data,1),numel(outputname));
for fi = 1:numel(outputname)
    name = outputname{fi};
    if isnumeric(Data.(name)(1))
        i = isnan(Data.(name));
        val(i,fi) = false;
        n = sum(i);
    elseif iscell(Data.(name)(1))
        i = cellfun(@isempty,Data.(name));
        val(i,fi) = false;
        n = sum(i);
    else
        error('code');
    end
    if reportdir
       fprintf('%d/%d contains %s\n',n,size(Data,1),name);
    else
        fprintf('%d missing %s\n',n,name);
    end
end

%%
k = sum(val,2)~=numel(outputname);
if reportdir
    fprintf('%d/%d complete info\n',sum(~k),size(Data,1));
else
    fprintf('%d missing complete info\n',sum(k));
end
