function T = table_AgexGender(age,gender)

%%


%%

u = unique(gender(~isnan(gender)));
if ismember(2,u)
   gender(gender==2) = 0;
end
% change gender NaN to 3
gender(isnan(gender))=3;
gu = unique(gender);
gendernames = translate_legend([0 1 3],{'Female','Male','Unknonwn'},gu);


%%
ageu = unique(age);
i = find(isnan(ageu));
if numel(i)>1
    ageu(i(2:end)) = [];
end
A = nan(numel(ageu,gu+1));
for ai = 1:numel(ageu)
    a = ageu(ai);
    if isnan(a); i = isnan(age);  else i = age==a; end
        
    for gi = 1:numel(gu)
        g = gu(gi);
        if isnan(g); j = isnan(gender);  else j = gender==g; end
        A(ai,gi) = sum(i&j);
    end
    A(ai,numel(gu)+1) = sum(i);
end

A = [ageu A];
T = array2table(A,'VariableNames',[{'age'};gendernames;{'Total'}]);


end

