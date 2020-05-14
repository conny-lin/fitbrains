function agegroup = convertAge2AgeGroup_5yr(age)

a = floor(age./10).*10;
last_digit = age - a;
b = zeros(size(a));
b(last_digit >= 5 & last_digit <=9) = 5;
agegroup = a+b;
