function fig1 = graph_barErrorMean_demographic(D,U,varargin)

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

%% figure
close all;
fig1 = figure('Visible',visible);
axes('XTickLabel',ageu,'XTick',1:numel(ageu),'FontSize',fontsize);
hold all
for ai = 1:numel(ageu)
    for geni = 1:numel(genderu)
        for ei = 1:numel(eduu)
            color = lege.color{lege.id==eduu(ei)};
            markerstyle = legg.markertype{legg.id==genderu(geni)};
%             reduce circle marker size
            if strcmp(markerstyle,'o')
                markersizeP = markersize/2;
            else
                markersizeP = markersize;
            end
            
            % get data
            i = U.agegroup==ageu(ai) & U.gender==genderu(geni) & U.education==eduu(ei);
            d = D(i);

            if ~isempty(d)
                % get errorbar
                y = mean(d);
                n = numel(d);
                e = std(d);
                % randomly shift x
                shift = rand(n,1);
                shift(shift > 0.5) = 0.25;
                shift(shift < 0.5 & shift ~=0.25) = -0.25;
                x = (rand(n,1)) .*shift;
                x = x+ai;

                % get outliers
                outliers = d;
                outliers(outliers<=y+(2*e) & outliers>=y-(2*e)) = [];

                % plot errorbar
                plot(x(1),y,'MarkerFaceColor','none',...
                    'MarkerEdgeColor',color,'Marker',markerstyle,...
                    'LineStyle','none','MarkerSize',markersizeP+3);

                % plot outliers
                if numel(outliers)~=0
                    plot(x(1:numel(outliers)),outliers,'MarkerFaceColor','none',...
                        'MarkerEdgeColor',color,'Marker',markerstyle,...
                        'LineStyle','none','MarkerSize',markersizeP);
                end
            end

        end
    end
end




ylabel(yname,'FontSize',fontsize);
xlabel(xname,'FontSize',fontsize);
