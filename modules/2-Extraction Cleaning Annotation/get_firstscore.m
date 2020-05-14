function Data = get_firstscore(Data)

D = [Data.user_id Data.played_at_utc Data.id];
D = sortrows(D,[1 2]);
[iStart,~,~,~] = find_userboundry(D(:,1));
scoreid = D(iStart,3);
Data = Data(ismember(Data.id,scoreid),:);