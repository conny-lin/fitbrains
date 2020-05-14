function agegroup = convertAge2AgeGroup(age)

%%
%  age = UI.age;
agegroup = floor(age./10).*10;
