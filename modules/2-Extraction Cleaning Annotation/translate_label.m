function label_id = translate_label(label)
a = label;
a(cellfun(@isempty,a)) = [];
label_id = cellfun(@str2num,a);