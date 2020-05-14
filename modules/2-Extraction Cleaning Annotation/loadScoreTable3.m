function [B] = loadScoreTable3(pData,suffix,varargin)
% loadScoreTable3  load fitbrains201403 data
%   this version uses matfile function to reduce memory load
%   
%     loadScoreTable3(pData,suffix)
%     loadScoreTable3(pData,suffix,fields, fields restrictions)
%   fields:
%
% examples:
% suffix = 'FBT_scoreVal';
% suffix = 'FBT_userinfo';
% V = {'agegroup',20:10:70,'gender','education'};
% 
% ** FIXES **
%   201505231739 - freq_day calculation removed timelapse_day == 0 to 
%   avoid results as Inf
% 
% ** FUTURE RELEASE **
% remove games with out proper index: load(sprintf('%s/index_gameidInvalid.mat',pData),'ind');


%% get input
V = varargin;
fprintf('-- start: %s: %s\n',mfilename,suffix);


%% separate variable and limits
VR = V(cellfun(@ischar,V));
ir = find(cellfun(@isnumeric,V));
VRwithlimit = V(ir-1);
Vlimit = V(ir);

VRnolimit = VR(~ismember(VR,VRwithlimit));

%% check if inputs has .mat file
a = dircontent(pData,[suffix,'*']);
a = regexprep(a,([suffix,'_']),'');
a = regexprep(a,'(.mat)','');
VRLoad = VR(ismember(VR,a));
VRCal = VRnolimit(~ismember(VRnolimit,a));


%% deal with var with restrictions and with .mat file
display 'Restricting import';
%% remove scores without proper game index
% this database is known to have 91254542 rows
nRow = 91254542;


V = VRwithlimit;
if isempty(V) == 0
    for x = 1:numel(V)
        Vnow = V{x}; % get variable
        res = Vlimit{x}; % get restriction terms
        A = matfile(sprintf('%s/%s_%s.mat',pData,suffix,Vnow));  % load var
        if x == 1; ival = true(size(A.(Vnow),1),1); end % create ival  

        % restrict file
        ival(~ismember(A.(Vnow),res)) = false;
        fprintf('%s: %d criteria %d/%d rows included\n',...
            Vnow,numel(res),sum(ival),numel(ival));
    end
else
    ival = [];
end



%% deal with variables to import without restriction
V = VRLoad;
nRowval = numel(ival); 
ival = find(ival);
B = table;
for x = 1:numel(V)
    Vnow = V{x}; % get variable
    if ismember(Vnow,fieldnames(B)) == 0
        if nRowval ==0 || nRowval == numel(ival)
            A = matfile(sprintf('%s/%s_%s.mat',pData,suffix,Vnow));
            B.(Vnow) = A.(Vnow);
        elseif nRowval ~= numel(ival)
            B = loadvar(B,Vnow,pData,suffix,ival);
        end
    end
    fprintf('-imported: %s\n',Vnow);
end


%% deal with known problems:
% if there is play time gameid and pscore imported, remove deplicate score
fnames = fieldnames(B);
tname = {'userid','playtime','gameid'};

if sum(ismember(tname,fnames)) == numel(tname)
    if ismember('score',fnames) == 1
        A = [B.userid B.playtime B.gameid B.score];
    elseif ismember('pscore',fnames) == 1
        A = [B.userid B.playtime B.gameid B.pscore];
    elseif ismember('pscoremax3Smooth',fnames) == 1
        A = [B.userid B.playtime B.gameid B.pscoremax3Smooth];  
    elseif ismember('pscoremax3',fnames) == 1
        A = [B.userid B.playtime B.gameid B.pscoremax3]; 
    end
    [~,i] = unique(A,'rows');
    fprintf('retain unique scores: %d/%d\n',numel(i),size(A,1));
    B = B(i,:);
end



%% process variables that needs calculation
if isempty(VRCal) == 0
    for x = 1:numel(VRCal)
        VRCN = VRCal{x};
        fprintf('-calculating: %s\n',VRCN);
        switch VRCN
            case 'timelapse'
                B = loadvar(B,'userid',pData,suffix,ival);
                B = loadvar(B,'playtime',pData,suffix,ival);
                B = calculateTimeLapse2(B);

            case 'timelapse_day'
                B = calculate_timelapse_day(B);

            case 'playN'
                B = calculate_playN(B,pData,suffix,ival);
                
            case 'freq_day' %% NEED CODING %%
                B = cal_freq_day(B);
            case 'agegroup_gender'    % create gender x agegroup
                B = loadvar(B,'agegroup',pData,suffix,ival);
                B = convert_gendername;
                d2 = char(B.gendername);
                d3 = repmat('x',size(d,1),1);
                d = [d,d3,d2];
                a = regexprep(cellstr(d),' ','');
                a = regexprep(a,'NaN','U');
                B.(VRCN) = a;
            
            case 'gendername'
                B = convert_gendername(B); % convert gender name
                
            otherwise
                fprintf('can not process this input: %s\n',VRCN)
        end
    end
end


%% eliminiate unwanted fields
fnames = fieldnames(B);
fnotwant = fnames(~ismember(fnames,[VR {'Properties'}]));
for x = 1:numel(fnotwant)
    B.(fnotwant{x}) = [];
end


%% report end
fprintf('-- complete: %s\n',mfilename);


%% nested functions
    function B = convert_gendername(B)
        B = loadvar(B,'gender',pData,suffix,ival);     
        A = matfile(sprintf('%s/%s_%s.mat',pData,suffix,'gender'));
        genderL = cell2mat(A.genderLegend(:,1));
        gendernameL = A.genderLegend(:,3);
        a = cell(size(B,1),1);
        a(isnan(B.gender)) = {'U'};
        [i,j] = ismember(B.gender,genderL);
        a(i) = gendernameL(j(i));
        B.gendername = a;
    end


    function B = cal_freq_day(B)
        % calculate frequency of play N / timelapse_day
        % must ignor zeros to avoid infinity
        if isfield(B,'playN') == 0
            B = calculate_playN(B,pData,suffix,ival);
        end
        if isfield(B,'timelapse_day') == 0
            B = calculate_timelapse_day(B);
        end
        a = B.timelapse_day;
        a(B.timelapse_day == 0) = nan ;
        B.freq_day = B.playN./a;
    end

    function B = calculate_timelapse_day(B)
        if ismember('timelapse_day',fieldnames(B)) == 0
            if ismember('timelapse',fieldnames(B)) == 1
                B.(VRCN) = B.timelapse./(60*60*24);
            else
                B = loadvar(B,'userid',pData,suffix,ival);
                B = loadvar(B,'playtime',pData,suffix,ival);
                B = calculateTimeLapse2(B);
                B.timelapse_day = B.timelapse./(60*60*24);
            end
        end
    end

    function B = calculateTimeLapse2(B)
    % Score must contain userid, playtime
    % [201505202000] found bug 
    % start time = 0 (as opposed to previous verion start time = 1)
        if ismember('timelapse',fieldnames(B)) == 0
            B = loadvar(B,'userid',pData,suffix,ival);
            B = loadvar(B,'playtime',pData,suffix,ival);
            if isstruct(B) == 1
                B = struct2table(B);
            end

            B.timelapse = nan(size(B,1),1);

            B = sortrows(B,{'userid','playtime'});

            % first row of a user id
            a = find([1;diff(B.userid)] > 0);
            % last row of a user id
            a(:,2) = [(a(2:end,1)-1); size(B,1)]; 

            % calculate time diff
            i = a(:,1);

            firstTime = [B.userid(i) B.playtime(i)];
            [~,j] = ismember(B.userid, firstTime(:,1));
            firstMatrix = firstTime(j,2);
            B.timelapse = B.playtime - firstMatrix;

            usb = a;
        end
    end


end









function B = loadvar(B,v,pData,suffix,ival)
%% load variable
    importpath = sprintf('%s/%s_%s.mat',pData,suffix,v);
    if ismember(v,fieldnames(B)) == 0
        A = load(importpath,v);
        if nargin >=5
            B.(v) = A.(v)(ival);
        else
            B.(v) = A.(v);
        end
    end
end


% function [Score, usb] = calculateTimeLapse2(Score,pData,suffix,ival)
% % Score must contain userid, playtime
% % [201505202000] found bug 
% % start time = 0 (as opposed to previous verion start time = 1)
%     if ismember('timelapse',fieldnames(Score)) == 0
%         Score = loadvar(Score,'userid',pData,suffix,ival);
%         Score = loadvar(Score,'playtime',pData,suffix,ival);
%         if isstruct(Score) == 1
%             Score = struct2table(Score);
%         end
% 
%         Score.timelapse = nan(size(Score,1),1);
% 
%         Score = sortrows(Score,{'userid','playtime'});
% 
%         % first row of a user id
%         a = find([1;diff(Score.userid)] > 0);
%         % last row of a user id
%         a(:,2) = [(a(2:end,1)-1); size(Score,1)]; 
% 
%         % calculate time diff
%         i = a(:,1);
% 
%         firstTime = [Score.userid(i) Score.playtime(i)];
%         [~,j] = ismember(Score.userid, firstTime(:,1));
%         firstMatrix = firstTime(j,2);
%         Score.timelapse = Score.playtime - firstMatrix;
% 
%         usb = a;
%     end
% 
% end


function  B = calculate_playN(B,pData,suffix,ival)
    if ismember('playN',fieldnames(B)) == 0
        if numel(unique(B.gameid)) > 1
            warning('no gameid >> calculating across game');
        end
        
        B = loadvar(B,'userid',pData,suffix,ival);
        B = loadvar(B,'playtime',pData,suffix,ival);
        B = calculateTimeLapse2(B,pData,suffix,ival);
        B = sortrows(B,{'userid','timelapse'});
        usb = find([1;diff(B.userid)]);
        usb(:,2) = [usb(2:end,1)-1; size(B,1)];
        % generate seq
        t = nan(size(B,1),1);
        for x = 1:size(usb,1)
            nstart = usb(x,1);
            nend =  usb(x,2);
            t(nstart:nend) = 1:(nend-nstart+1);
        end
        B.playN = t;
    end
end

% function B = calculate_timelapse_day(B,pData,suffix,ival)
%     if ismember('timelapse_day',fieldnames(B)) == 0
%         if ismember('timelapse',fieldnames(B)) == 1
%             B.(VRCN) = B.timelapse./(60*60*24);
%         else
%             B = loadvar(B,'userid',pData,suffix,ival);
%             B = loadvar(B,'playtime',pData,suffix,ival);
%             B = calculateTimeLapse2(B,pData,suffix,ival);
%             B.timelapse_day = B.timelapse./(60*60*24);
%         end
%     end
% end







