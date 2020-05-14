function [t,id,name] = legend_gender

% create gender legend
t = table;
id = [0;1;NaN];
t.id = id;
name = {'Female';'Male';'Unknonwn'};
t.name = name;
