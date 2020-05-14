function output_name = translate_legend(id,name,input_id)

%% translate
output_name = cell(size(input_id));
[i,j] = ismember(input_id,id);
output_name(i) = name(j(i));

%% deal with nan id
if sum(isnan(id))==1
   output_name(isnan(input_id)) = name(isnan(id));
end

