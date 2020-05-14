function report_uniquevalues(Data)

varnames = Data.Properties.VariableNames;
n = size(Data,1);
for vi = 1:numel(varnames)
    vn = varnames{vi};
    un = unique(Data.(vn));
    fprintf('%d/%d unique %s\n',numel(un),n,vn);
end