%DOC plots for lightening talk otherwise too many!

load \\sosiknas1\Lab_data\LTER\DOC\DOCtable.mat
symbol = 'o^sh'; %for loops to plot diff symbols

%%
%load bathy mat file to draw bottom line
ilat = 39.5:.05:41.5;
ilon = ones(size(ilat)).*-70.8855;
idpth = 0:1:200;
bdata = load('ngdc2.mat'); %from Gordon
ibdpth = griddata(bdata.lon',bdata.lat,bdata.h,ilon(:),ilat(:));
%%

%1 Fig all lat vs depth organized by year&season
%only include axes labels on edge plots and move color bar to right side of fig with bigger labeled numbers
figure
filler=0;
for yearct = 1:length(sampling_yrs)
    for count = 1:4     
        ind = find(ismember(DOCtable.season, season(count)) &  year(DOCtable.date) == sampling_yrs(yearct)); %find the ind of any DOCtable row in that season for all cruises
        if ~isempty(ind)
        flagged = find(DOCtable.quality_flag_c(ind) >1);
        subplot(length(sampling_yrs),4,count+filler)
        plot(ilat,ibdpth,'color',[0.5 0.5 0.5]);
        hold on
        scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.npoc(ind),'filled');
        plot(DOCtable.latitude(ind(flagged)),DOCtable.depth(ind(flagged)),'ro')
        title([char(season(count)) ' ' num2str(year(DOCtable.date(ind(1)))) ' - ' char(DOCtable.cruise(ind(1)))])
        grid on
        set(gca, 'YDir','reverse')
        ylim([0 200]) %only L11 500m samples deeper than 110, can't really see range when everythign scrunched at surf
        set(gca, 'XDir','reverse')
        xlim([39.70 41.2])
        clim(docrange)
        if yearct == 3 && count ==1
        c = colorbar;
        end
        end
    end
    filler = filler+4;
end
subplot(441); ylabel('Depth (m)','fontweight','bold');
subplot(445); ylabel('Depth (m)','fontweight','bold') ;
subplot(449); ylabel('Depth (m)','fontweight','bold'); xlabel('Latitude','fontweight','bold')
subplot(4,4,13); ylabel('Depth (m)','fontweight','bold') ;
subplot(446); xlabel('Latitude','fontweight','bold');
subplot(447); xlabel('Latitude','fontweight','bold');
subplot(448); xlabel('Latitude','fontweight','bold');
%NEEDS FIXING c.FontSize = 12;
%NEEDS FIXING c.Position = [0.93 0.168 0.022 0.7];

%save figure
set(gcf, 'position', [1 41 1536 748])
print([p 'plots' filesep 'DOC_transect_contour_all_v2'], '-dpng')
clear c

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%TS PLOTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TS diagram with contours plotting DOC with season symbols
%SURFACE
figure
theta_sdiag(DOCtable.temperature,DOCtable.salinity);
hold on
for count = 1:4
%     ind = find(DOCtable.season == season(count) & DOCtable.depth <7);
    ind = find(DOCtable.season == season(count) & DOCtable.depth >85 & DOCtable.depth < 142);
    scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc(ind),'filled','marker',symbol(count));
end
colorbar; clim(docrange);
h=get(gca,'children');
legend(flip(h(1:4)),'winter','spring','summer','fall','location','southeast')
title('SURFACE DOC TS plot')
%save figure
print([p 'plots' filesep 'TS_DOC_surf_season'], '-dpng')

%TS diagram with contours plotting DOC with season symbols
figure
theta_sdiag(DOCtable.temperature,DOCtable.salinity);
hold on
for count = 1:4
    ind = find(DOCtable.season == season(count));
    scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc(ind),'filled','marker',symbol(count));
end
colorbar; clim(docrange);
%NEEDS FIXING legend(flip(h(1:4)),'winter','spring','summer','fall','location','southeast')
title('ALL DOC TS plot')
%save figure
print([p 'plots' filesep 'TS_DOC_all'], '-dpng')

%1 FIG SEASONS TS diagram with contours plotting DOC with season symbols
figure; 
set(gcf,'Position',[169 49 878 712]);
for count = 1:4
subplot(2,2,count)
theta_sdiag(DOCtable.temperature,DOCtable.salinity);
hold on
temptable = DOCtable(DOCtable.season == season(count),:);
cruises = unique(temptable.cruise);
for count2 = 1:length(cruises)
    ind = find(temptable.cruise == cruises(count2));
    scatter(temptable.salinity(ind),temptable.temperature(ind),[],temptable.npoc(ind),'filled','marker',symbol(count2));
end
ax=get(gca,'Children'); forleg = length(ax)-1;
legend(ax(flip(1:forleg)),cruises);
clim(docrange)
title(['DOC ' char(season(count))])
clear forleg in count2 ax 
end
c=colorbar; 
c.FontSize = 12;
c.Position = [0.93 0.168 0.022 0.7];
%save figure
print([p 'plots' filesep 'TS_DOC_seasons'], '-dpng')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%DISTURBANCE AR77 COLD POOL
ind = find(DOCtable.cruise == 'AR77');
figure
subplot 121
    plot(ilat,ibdpth,'color',[0.5 0.5 0.5]);
    hold on
    scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.npoc(ind),'filled');
    title('DOC - fall 2023 - AR77','fontsize',16); xlabel('Latitude','fontweight','bold'); ylabel('Depth','fontweight','bold');
    grid on
    set(gca, 'YDir','reverse'); set(gca, 'XDir','reverse');
    ylim([0 200]) %only L11 500m samples deeper than 110, can't really see range when everythign scrunched at surf
    xlim([39.70 41.2])
    clim(docrange); c = colorbar; c.FontSize = 12;
subplot 122
    plot(ilat,ibdpth,'color',[0.5 0.5 0.5]);
    hold on
    scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.tn(ind),'filled');
    title('DTN - fall 2023 - AR77','fontsize',16); xlabel('Latitude','fontweight','bold'); ylabel('Depth','fontweight','bold');
    grid on
    set(gca, 'YDir','reverse'); set(gca, 'XDir','reverse');
    ylim([0 200]) %only L11 500m samples deeper than 110, can't really see range when everythign scrunched at surf
    xlim([39.70 41.2])
    clim(tnrange); c = colorbar; c.FontSize = 12;
set(gcf,'Position',[26 289 1324 473])
print([p 'plots' filesep 'AR77_DOC_DTN_lat_vs_depths'], '-dpng')

%DISTURBANCE EN712 TRACK FOOT OF FRONT?
ind = find(DOCtable.cruise == 'EN712');
figure
subplot 121
    plot(ilat,ibdpth,'color',[0.5 0.5 0.5]);
    hold on
    scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.npoc(ind),'filled');
    title('DOC - winter 2024 - EN712','fontsize',16); xlabel('Latitude','fontweight','bold'); ylabel('Depth','fontweight','bold');
    grid on
    set(gca, 'YDir','reverse'); set(gca, 'XDir','reverse');
    ylim([0 500]) %tracking foot of front slope water deep L9 interesting
    xlim([39.70 41.2])
    c = colorbar; c.FontSize = 12; %clim(docrange); 
subplot 122
    plot(ilat,ibdpth,'color',[0.5 0.5 0.5]);
    hold on
    scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.tn(ind),'filled');
    title('DTN - winter 2024 - EN712','fontsize',16); xlabel('Latitude','fontweight','bold'); ylabel('Depth','fontweight','bold');
    grid on
    set(gca, 'YDir','reverse'); set(gca, 'XDir','reverse');
    ylim([0 500]) %tracking foot of front slope water deep L9 interesting
    xlim([39.70 41.2])
    c = colorbar; c.FontSize = 12; %clim(tnrange); 
set(gcf,'Position',[26 289 1324 473])
print([p 'plots' filesep 'EN712_DOC_DTN_lat_vs_depths'], '-dpng')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%INCLUDE THIS PLOT LAST BECAUSE SORT table in different way for better
%%lookign plot
%SORT BEFORE LINE PLOT OF DIFF DEPTHS
%sort list by latitude to easily plot .- and have not go every which way
[b,ind] = sort(DOCtable.latitude);
DOCtable = DOCtable(ind,:);
docrange = [40 95]; %reset doc range to see on yaxis, previously was set for colorbar

%1 GIANT plot latitude DOC lines colored by depth interval. per season seasons
figure
filler = 0;
for yearct = 1:length(sampling_yrs)
for count = 1:4
    temptable = DOCtable(ismember(DOCtable.season, season(count)) &  year(DOCtable.date) == sampling_yrs(yearct),:);
    if ~isempty(temptable)
    subplot(length(sampling_yrs),4,count+filler)
    plot(temptable.latitude(temptable.depth < 6),temptable.npoc(temptable.depth < 6),'.-b','markersize',15)
    hold on
    plot(temptable.latitude(temptable.depth > 6 & temptable.depth < 70),temptable.npoc(temptable.depth > 6 & temptable.depth < 70),'.-g','markersize',15)
    plot(temptable.latitude(temptable.depth > 70 & temptable.depth < 150),temptable.npoc(temptable.depth > 70 & temptable.depth < 150),'.-r','markersize',15)
    plot(temptable.latitude(temptable.depth > 200),temptable.npoc(temptable.depth > 200),'.-k','markersize',15)
    plot(temptable.latitude(temptable.depth > 150 & temptable.depth < 200),temptable.npoc(temptable.depth > 150 & temptable.depth < 200),'.-m','markersize',15)
    grid on
    axis([39.5 41.5 40 110])
    set(gca,'XDir','reverse')
    title([cell2mat(theseasons(count)) ' ' num2str(year(temptable.date(1))) ' - ' char(temptable.cruise(1))])
    end
end
filler = filler+4;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%for annual meeting plot
legend({'surface','6<D<70','70<D<150','>200m'},'fontsize',12,'position',[0.3337 0.1540 0.1114 0.1263]);
subplot(441); ylabel('Depth (m)','fontweight','bold');
subplot(445); ylabel('Depth (m)','fontweight','bold');
subplot(449); ylabel('Depth (m)','fontweight','bold'); 
subplot(4,4,13); ylabel('Depth (m)','fontweight','bold') ; xlabel('Latitude','fontweight','bold')
subplot(4,4,10); xlabel('Latitude','fontweight','bold')
subplot(4,4,11); xlabel('Latitude','fontweight','bold')
subplot(4,4,12); xlabel('Latitude','fontweight','bold')
set(gcf,'position',[40 54 1100 700])
% [43.4000 54.6000 1.1328e+03 702.4000]
print([p 'plots' filesep 'DOC_transect_lat_vs_DOC_per_season_grouped_depths_all'], '-dpng')

%%plot surf DOC by latitude for diff seasons
docrange = [40 110];
ind = find(DOCtable.season == 'winter' & DOCtable.depth <10);
figure
plot(DOCtable.latitude(ind),DOCtable.npoc(ind),'bo','MarkerSize',7,'MarkerFaceColor','b')
hold
ind = find(DOCtable.season == 'summer' & DOCtable.depth <10);
plot(DOCtable.latitude(ind),DOCtable.npoc(ind),'rs','MarkerSize',7,'MarkerFaceColor','r')
ind = find(DOCtable.season == 'spring' & DOCtable.depth <10);
plot(DOCtable.latitude(ind),DOCtable.npoc(ind),'g^','MarkerSize',7,'MarkerFaceColor','g')
ind = find(DOCtable.season == 'fall' & DOCtable.depth <10);
plot(DOCtable.latitude(ind),DOCtable.npoc(ind),'kh','MarkerSize',7,'MarkerFaceColor','k')
legend('winter','summer','spring','fall')ylim(docrange)
xlabel('Latitude','FontWeight','bold')
ylabel('DOC (uM)','fontweight','bold')
title('Surface DOC across Latitude')
grid
set(gca, 'XDir','reverse')