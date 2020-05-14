function agegroup = convertAge2AgeGroup_5yr10yr(age)


%% deal with 10 years
agegroup = floor(age./10).*10;

%% deal with 5 years below 19
a = floor(age./10).*10;
last_digit = age - a;
b = zeros(size(a));
b(last_digit >= 5 & last_digit <=9) = 5;
c = a+b;
agegroup(age<19) = c(age<19);


