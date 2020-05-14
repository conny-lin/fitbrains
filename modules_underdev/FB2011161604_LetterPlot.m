% function FB201505221343_201505250946
% FB201505221343_201505250946   rearrange FB201505221343 output to get 
%       playN x time-lapse plot per IV group
% 

%% DEFINE VARIABLES AND PATHS
% define input data information
pData = '/Users/connylin/OneDrive/FB/Database';
DataFolderName = 'FitBrainsTrainer_20140314_Matlab_Transformed';
pData = [pData,'/',DataFolderName];

% add function library
addpath('/Users/connylin/Dropbox/MATLAB/Function_Library_Public');
addpath('/Users/connylin/Dropbox/MATLAB/FB/Library_FB');
% create output folder
pOH = createOutputFolder(which(mfilename));
% pConv = sprintf('%s/ScorePercentileRef',pData);
% path to input files
pFin = sprintf('%s/Data/FB201505221343_a201505231909',pOH);
pO = [pOH,'/Graph']; if isdir(pO) == 0; mkdir(pO); end


%% examine file contents
xAxis = 'playN';
yAxis = 'timelapse_day';
FileNames = struct;
FileNames.(xAxis) = dircontent(pFin,[xAxis,'*.txt']);
FileNames.(yAxis) = dircontent(pFin,[yAxis,'*.txt']);


%% import files
Import = struct;
fnames = fieldnames(FileNames);
for f = 1:numel(fnames)
    dv = fnames{f};
    for x = 1:numel(FileNames.(dv))
        % get current filenames
        filename = FileNames.(dv){x};
        fprintf('importing %s\n',filename);
        % get tier name
        a = regexp(filename,' ','split');
        tier = a{:,3};
        %
        Import.(dv).(tier) = dlmread(...
                sprintf('%s/%s',pFin,filename),'\t',1,1);
    end
end

%% get rownames (groups)
formatSpec = '%s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
delimiter = '\t';
startRow = 2;
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, ...
    'Delimiter', delimiter, 'HeaderLines' ,startRow-1, ...
    'ReturnOnError', false);
rowNames = cellstr(dataArray{1});
fclose(fileID);
% fix rownames
rowNamesV = rowNames;
rowNamesV(ismember(rowNames,{'20','30','40', '50','60','70'})) = ...
    {'age20','age30','age40', 'age50','age60','age70'};
rowNamesV = regexprep(rowNamesV,' ','_');

% get col names (gametype-gamename_stats)
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
delimiter = '\t'; endRow = 1;
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'ReturnOnError', false);
dataArray = dataArray(2:end-1)';
colNames = celltakeout(dataArray,'multirow');
fclose(fileID);

% get gametypes
a = char(colNames);
gametype = a(:,1);
gametypeU = cellstr(unique(gametype));

% get gamename code
gamecode = a(:,1:2);
gamecodeU = unique(cellstr(gamecode));

% get stats name
statName = regexpcellout(colNames,'_','split');
statName = statName(:,2);
statNameU = unique(statName);

% get tier names
tiernames = fieldnames(Import.(xAxis));

% datatype
datatype = fieldnames(Import);

% find max playN and time
xMax = max(structfun(@max,structfun(@max,Import.playN,'UniformOutput',0)));
yMax = max(structfun(@max,structfun(@max,Import.timelapse_day,'UniformOutput',0)));


%% rearrange
% into structural array,
% Data.group(rowNames).gametype.gamecode.tier.stats(mean, N).datatype
% se)
Data = struct;
for gni = 1:numel(rowNames)
    gn = rowNames{gni};
    gnV = rowNamesV{gni};
    for gci = 1:numel(gamecodeU)
        gc = gamecodeU{gci};
        for di = 1:numel(datatype)
            dt = datatype{di};
            for tri = 1:numel(tiernames)
                tr = tiernames{tri};
                for sti = 1:numel(statNameU)
                    st = statNameU{sti};
                    ri = ismember(rowNames,{gn});
                    ci = ismember(colNames,{[gc,'_',st]});
                    Data.(gnV).(gc).(tr).(dt).(st) = Import.(dt).(tr)(ri,ci);

                end
            end
        end

    end
end


%% graph1
gccolor = [0.5 0.5 0.5; 0 0 0; 
            0 0 1; 0 0 0.8; 0 0 0.7;
            1 0 0; 0.8 0 0;
            0 0.8 0; 0 0.8 0.5; 0 0.5 0;
            0.5 0 0.5; 0.8 0 0.8];
gncolor = [0 0 0; 1 0 0; 1 0.5 0; 1 1 0; 0.5 0.8 0; 0 0 1; 0.5 0 0.5];
tiercolor = [1 0 0; 1 0.5 0; 1 1 0; 0.5 0.8 0; 0 0 1; 0.5 0 0.5];


for gni = 1:10%numel(rowNames)
    gn = rowNamesV{gni};
    gnName = rowNames{gni};
    figure1 = figure('Visible','off');
    axes1 = axes('Parent',figure1,'FontSize',25);
    hold(axes1,'all');
    xMax = -1; yMax = -1;
    for gci = 1:numel(gamecodeU)
        gc = gamecodeU{gci};
        for tri = 1:numel(tiernames)
            tr = tiernames{tri};
            xm = Data.(gn).(gc).(tr).(datatype{1}).('mean');
            ym = Data.(gn).(gc).(tr).(datatype{2}).('mean');
            xse = Data.(gn).(gc).(tr).(datatype{1}).('SE');
            yse = Data.(gn).(gc).(tr).(datatype{2}).('SE');
            x = xm - xse;
            y = ym - yse;
            w = xse*2;
            h = yse*2;
            rectangle('Position',[x,y,w,h],'EdgeColor','none','FaceColor','none')
            text(xm,ym,tr,'FontSize',20,'FontUnits','normalized','Color',gccolor(gci,:),...
                'BackgroundColor','none')
            hold on
            if xMax < (x + xse); xMax = (x + xse); end
            if yMax < (y + yse); yMax = (y + yse); end
        end
    end
    % draw horizontal lines
    xMax = ceil(xMax); yMax = ceil(yMax);
    for x = 10:10:xMax
        line([x x],[0 ceil(yMax/10)*10],'Color',[0 0 0],'LineStyle','--')
    end
    for y = 10:10:yMax
        line([0 ceil(xMax/10)*10],[y y],'Color',[0 0 0],'LineStyle','--')
    end
    for x = 5:10:xMax
        line([x x],[0 ceil(yMax/10)*10],'Color',[0 0 0],'LineStyle',':')
    end
    for y = 5:10:yMax
        line([0 ceil(xMax/10)*10],[y y],'Color',[0 0 0],'LineStyle',':')
    end
    xlim([0 xMax+1]);
    ylim([0 yMax+1]);
    % make lables
    ylabel(regexprep(datatype{2},'_',' '),'FontSize',20);
    xlabel(datatype{1},'FontSize',20);
    title(gnName,'FontSize',20);
    savefigepsOnly(['axisauto ',gnName],pO);
end


%% graph2
for gni = 1:10%numel(rowNames)
    gn = rowNamesV{gni};
    gnName = rowNames{gni};
    for gci = 1:numel(gamecodeU)
        gc = gamecodeU{gci};
        for tri = 1:numel(tiernames)
            tr = tiernames{tri};
            % plot
            xm = Data.(gn).(gc).(tr).(datatype{1}).('mean');
            ym = Data.(gn).(gc).(tr).(datatype{2}).('mean');
            xse = Data.(gn).(gc).(tr).(datatype{1}).('SE');
            yse = Data.(gn).(gc).(tr).(datatype{2}).('SE');
            x = xm - xse;
            y = ym - yse;
            w = xse*2;
            h = yse*2;
            % rectangle('Position',[x,y,w,h],'EdgeColor',gncolor(gni,1:3),'FaceColor',gtcolor(gti,1:3))
            rectangle('Position',[x,y,w,h],'EdgeColor','none','FaceColor','none')
            text(xm,ym,tr,'FontSize',12,'FontUnits','normalized','Color',gccolor(gci,:),...
                'BackgroundColor','none')
            % 'EdgeColor',gncolor(gni,:)
            hold on
        end
    end
    ylabel(regexprep(datatype{2},'_',' '),'FontSize',14);
    xlabel(datatype{1},'FontSize',14);
    ylim([0 140]);
    xlim([0 85]);
    title(gnName,'FontSize',18);
    savefigepsOnly150(['axislim ',gnName],pO);
end



%% CODING STOP
disp('coding stop'); return









