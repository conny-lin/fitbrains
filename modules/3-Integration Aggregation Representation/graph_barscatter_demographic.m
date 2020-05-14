function fig1 = graph_barscatter_demographic(D,U,varargin)

%% default
markersize =1;
visible='off';
yname = 'Y';
xname = 'X';
fontsize = 10;

%% varargin
vararginProcessor
%% load preferred IV list
pLegend = '/Users/connylin/Dropbox/Code/Matlab/Library FB/Modules/2-Extraction Cleaning Annotation';
cd(pLegend);
a= load('legend_age.mat','legend_agegroup1015');
lega = a.legend_agegroup1015;
a = load('legend_gender.mat','legend_gender_binary');
legg = a.legend_gender_binary;
a = load('legend_education.mat','legend_education_table');
lege = a.legend_education_table;



%% make 3 demogrpahic scatter plot
ageu = getuniquegroup(U.agegroup,0);
ageu(~ismember(ageu,lega.id(~isnan(lega.id)))) = [];
genderu = getuniquegroup(U.gender,0);
eduu = getuniquegroup(U.education,0);

%%
fig1 = figure('Visible',visible);
axes('XTickLabel',ageu,'XTick',1:numel(ageu));
hold on
for ai = 1:numel(ageu)
    for geni = 1:numel(genderu)
        for ei = 1:numel(eduu)
            color = lege.color{lege.id==eduu(ei)};
            markerstyle = legg.markertype{legg.id==genderu(geni)};
            i = U.agegroup==ageu(ai) & U.gender==genderu(geni) & U.education==eduu(ei); 
            y = D(i);
            n = numel(y);
            x = ones(n,1);
            % randomly shift dots
            shift = rand(n,1);
            shift(shift > 0.5) = 0.25;
            shift(shift < 0.5 & shift ~=0.25) = -0.25;
            x = (rand(n,1)) .*shift;
            x = x+ai;
            % reduce circle marker size
            if strcmp(markerstyle,'o')
                markersizeP = markersize/2;
            else
                markersizeP = markersize;
            end
            
            % plot
            plot(x,y,'MarkerFaceColor',color,...
                'MarkerEdgeColor',color,'Marker',markerstyle,...
                'LineStyle','none','MarkerSize',markersizeP);
        end
    end
end




ylabel(yname,'FontSize',fontsize);
xlabel(xname,'FontSize',fontsize);
