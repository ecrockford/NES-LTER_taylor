%Taylor 10/5/2022
%just playing around with initial DOC data to see initial results
%do they make sense? how'd our diff sampling strategies fair?

load \\sosiknas1\Lab_data\LTER\DOC\DOCtable.mat

%%
%load bathy mat file to draw bottom line
ilat = 39.5:.05:41.5;
ilon = ones(size(ilat)).*-70.8855;
idpth = 0:1:200;
bdata = load('ngdc2.mat'); %from Gordon
ibdpth = griddata(bdata.lon',bdata.lat,bdata.h,ilon(:),ilat(:));
%%


%1fig per year, TS with pcolor ratio, DOC, and TN. Not very helpful?....
%NOT THAT HELPFUL - ratio and TN not much?
%{
for yearct = 1:length(sampling_yrs)
    figure
    for count = 1:4 %length(cruises)    
        ind = find(ismember(DOCtable.season, season(count)) &  year(DOCtable.date) == sampling_yrs(yearct)); %find the ind of any DOCtable row in that season for all cruises
        if ~isempty(ind)
        subplot(3,4,count)
            flagged = find(DOCtable.quality_flag_c(ind) >1 | DOCtable.quality_flag_n(ind) >1);
            scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc(ind)./DOCtable.tn(ind),'filled');
            hold on
            plot(DOCtable.salinity(flagged),DOCtable.temperature(flagged),'ro')
            grid on; colorbar; axis([saltrange temprange]);
            xlabel('Salinity','fontweight','bold'); ylabel('Temperature','fontweight','bold'); title([char(DOCtable.cruise(ind(1))) ' C:N ratio'])
        subplot(3,4,count+4)
            flagged = find(DOCtable.quality_flag_c(ind) >1);
            scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc(ind),'filled');
            hold on
            plot(DOCtable.salinity(flagged),DOCtable.temperature(flagged),'ro')
            grid on; colorbar; axis([saltrange temprange]);
            xlabel('Salinity','fontweight','bold'); ylabel('Temperature','fontweight','bold'); title([char(DOCtable.cruise(ind(1))) ' DOC'])
        subplot(3,4,count+8)
            flagged = find(DOCtable.quality_flag_n(ind) >1);
            scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.tn(ind),'filled');
            hold on
            plot(DOCtable.salinity(flagged),DOCtable.temperature(flagged),'ro')
            grid on; colorbar; axis([saltrange temprange]);
            xlabel('Salinity','fontweight','bold'); ylabel('Temperature','fontweight','bold'); title([char(DOCtable.cruise(ind(1))) ' TN'])
        end
    end
end
%}


%DOC colored plot lat vs depth. new plot per yr. 
for yearct = 1:length(sampling_yrs)
    figure
    for count = 1:4 %length(cruises)    
        ind = find(ismember(DOCtable.season, season(count)) &  year(DOCtable.date) == sampling_yrs(yearct)); %find the ind of any DOCtable row in that season for all cruises
%         ind = find(ismember(DOCtable.cruise, cruises(season == categorical(theseasons(count)))) &  year(DOCtable.date) == sampling_yrs(yearct)); %find the ind of any DOCtable row in that season for all cruises
        if ~isempty(ind)
            flagged = find(DOCtable.quality_flag_c(ind) >1);
        subplot(4,1,count)
        scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.npoc(ind),'filled');
        hold on
        plot(DOCtable.latitude(ind(flagged)),DOCtable.depth(ind(flagged)),'ro')
        title(['DOC by depth across NESLTER transect in ' cell2mat(theseasons(count)) ' ' num2str(year(DOCtable.date(ind(1)))) ' on ' char(DOCtable.cruise(ind(1)))])
    %     title(['DOC by depth across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
        grid on
        set(gca, 'YDir','reverse')
        ylim([0 200]) %only L11 500m samples deeper than 110, can't really see range when everythign scrunched at surf
    %     ylim([0 510]) %some of samples slightly deeper than 500m, 502 is max but want to be able to see dot ok
        set(gca, 'XDir','reverse')
        xlim([39.70 41.2])
        ylabel('Depth (m)','fontweight','bold')
        xlabel('Latitude','fontweight','bold')
%         clim(docrange)
        colorbar
        end
    end
    %save figure
    set(gcf, 'position', [488 41.8 560 740.8])
    print([p 'plots' filesep 'DOC_transect_contour_' num2str(sampling_yrs(yearct))], '-dpng')
end
clear c

%1 GIANT FIGURE OF PREVIOUS LOOP
%DOC colored plot lat vs depth. new plot per yr.
figure
filler=0;
for yearct = 1:length(sampling_yrs)
    for count = 1:4     
        ind = find(ismember(DOCtable.season, season(count)) &  year(DOCtable.date) == sampling_yrs(yearct)); %find the ind of any DOCtable row in that season for all cruises
        if ~isempty(ind)
            flagged = find(DOCtable.quality_flag_c(ind) >1);
%         switch 
        subplot(length(sampling_yrs),4,count+filler)
        plot(ilat,ibdpth,'color',[0.5 0.5 0.5]);
        hold on
        scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.npoc(ind),'filled');
        plot(DOCtable.latitude(ind(flagged)),DOCtable.depth(ind(flagged)),'ro')
        title([char(season(count)) ' ' num2str(year(DOCtable.date(ind(1)))) ' - ' char(DOCtable.cruise(ind(1)))])
    %     title(['DOC by depth across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
        grid on
        set(gca, 'YDir','reverse')
        ylim([0 200]) %only L11 500m samples deeper than 110, can't really see range when everythign scrunched at surf
    %     ylim([0 510]) %some of samples slightly deeper than 500m, 502 is max but want to be able to see dot ok
        set(gca, 'XDir','reverse')
        xlim([39.70 41.2])
%         ylabel('Depth (m)','fontweight','bold')
%         xlabel('Latitude','fontweight','bold')
        clim(docrange)
%         colorbar
        end
    end
    filler = filler+4;
end
subplot(341); ylabel('Depth (m)','fontweight','bold');
subplot(345); ylabel('Depth (m)','fontweight','bold') ;
subplot(349); ylabel('Depth (m)','fontweight','bold'); xlabel('Latitude','fontweight','bold')
subplot(346); xlabel('Latitude','fontweight','bold');
subplot(347); xlabel('Latitude','fontweight','bold');
subplot(348); xlabel('Latitude','fontweight','bold');

%save figure
    set(gcf, 'position', [1 41 1536 748])
    print([p 'plots' filesep 'DOC_transect_contour_all'], '-dpng')
clear c


%1 GIANT FIGURE OF PREVIOUS LOOP
%DTN colored plot lat vs depth. new plot per yr.
figure
filler=0;
for yearct = 1:length(sampling_yrs)
    for count = 1:4     
        ind = find(ismember(DOCtable.season, season(count)) &  year(DOCtable.date) == sampling_yrs(yearct)); %find the ind of any DOCtable row in that season for all cruises
        if ~isempty(ind)
            flagged = find(DOCtable.quality_flag_n(ind) >1);
%         switch 
        subplot(length(sampling_yrs),4,count+filler)
        plot(ilat,ibdpth,'color',[0.5 0.5 0.5]);
        hold on
        scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.tn(ind),'filled');
        plot(DOCtable.latitude(ind(flagged)),DOCtable.depth(ind(flagged)),'ro')
        title(['DTN ' char(season(count)) ' ' num2str(year(DOCtable.date(ind(1)))) ' - ' char(DOCtable.cruise(ind(1)))])
    %     title(['DOC by depth across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
        grid on
        set(gca, 'YDir','reverse')
%         ylim([0 200]) %only L11 500m samples deeper than 110, can't really see range when everythign scrunched at surf
        ylim([0 510]) %some of samples slightly deeper than 500m, 502 is max but want to be able to see dot ok
        set(gca, 'XDir','reverse')
        xlim([39.70 41.2])
%         ylabel('Depth (m)','fontweight','bold')
%         xlabel('Latitude','fontweight','bold')
        clim(tnrange)
%         colorbar
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
c.FontSize = 12;
c.Position = [0.93 0.168 0.022 0.7];

%save figure
    set(gcf, 'position', [1 41 1536 748])
    print([p 'plots' filesep 'DTN_transect_contour_all'], '-dpng')
clear c





%TN colored plot lat vs depth. new plot per yr. 
%
for yearct = 1:length(sampling_yrs)
    figure
    for count = 1:4 %length(cruises)    
        ind = find(ismember(DOCtable.season, season(count)) &  year(DOCtable.date) == sampling_yrs(yearct)); %find the ind of any DOCtable row in that season for all cruises
%         ind = find(ismember(DOCtable.cruise, cruises(season == categorical(theseasons(count)))) &  year(DOCtable.date) == sampling_yrs(yearct) & DOCtable.depth <= 200); %find the ind of any DOCtable row in that season for all cruises
        if ~isempty(ind)
            flagged = find(DOCtable.quality_flag_n(ind)>1);
        subplot(4,1,count)
        scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.tn(ind),'filled');
        hold on
        plot(DOCtable.latitude(ind(flagged)),DOCtable.depth(ind(flagged)),'ro')
        title(['TN by depth across NESLTER transect in ' cell2mat(theseasons(count)) ' ' num2str(year(DOCtable.date(ind(1)))) ' on ' char(DOCtable.cruise(ind(1)))])
    %     title(['DOC by depth across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
        grid on
        set(gca, 'YDir','reverse')
%         ylim([0 200]) %only L11 500m samples deeper than 110, can't really see range when everythign scrunched at surf
        ylim([0 510]) %some of samples slightly deeper than 500m, 502 is max but want to be able to see dot ok
        set(gca, 'XDir','reverse')
        xlim([39.70 41.2])
        ylabel('Depth (m)','fontweight','bold')
        xlabel('Latitude','fontweight','bold')
%         clim(tnrange)
        colorbar
        end
    end
    %save figure
    set(gcf, 'position', [488 41.8 560 740.8])
%     print([p 'plots' filesep 'TN_transect_contour_' num2str(sampling_yrs(yearct))], '-dpng')
end
%}

%C:N ratio colored plot lat vs depth. new plot per yr. 
%{
for yearct = 1:length(sampling_yrs)
    figure
    for count = 1:4 %length(cruises)    
        ind = find(ismember(DOCtable.cruise, cruises(season == categorical(theseasons(count)))) &  year(DOCtable.date) == sampling_yrs(yearct) & DOCtable.depth <= 200); %find the ind of any DOCtable row in that season for all cruises
        if ~isempty(ind)
            flagged = find(DOCtable.quality_flag_c(ind) >1 | DOCtable.quality_flag_n(ind)>1);
        subplot(4,1,count)
        scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.npoc(ind)./DOCtable.tn(ind),'filled');
        hold on
        plot(DOCtable.latitude(ind(flagged)),DOCtable.depth(ind(flagged)),'ro')
        title(['C:N ratio by depth across NESLTER transect in ' cell2mat(theseasons(count)) ' ' num2str(year(DOCtable.date(ind(1)))) ' on ' char(DOCtable.cruise(ind(1)))])
    %     title(['DOC by depth across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
        grid on
        set(gca, 'YDir','reverse')
        ylim([0 200]) %only L11 500m samples deeper than 110, can't really see range when everythign scrunched at surf
    %     ylim([0 510]) %some of samples slightly deeper than 500m, 502 is max but want to be able to see dot ok
        set(gca, 'XDir','reverse')
        xlim([39.70 41.2])
        ylabel('Depth (m)','fontweight','bold')
        xlabel('Latitude','fontweight','bold')
%         clim(tnrange)
        colorbar
        end
    end
    %save figure
    set(gcf, 'position', [488 41.8 560 740.8])
    print([p 'plots' filesep 'CtoNratio_transect_contour_' num2str(sampling_yrs(yearct))], '-dpng')
end
%}


%sort list by latitude to easily plot .- and have not go every which way
[b,ind] = sort(DOCtable.latitude);
DOCtable = DOCtable(ind,:);
docrange = [40 95]; %reset doc range to see on yaxis, previously was set for colorbar

%plot latitude DOC lines colored by depth interval. 1 fig per yr.  4 seasons
%{
for yearct = 1:length(sampling_yrs)
    figure
for count = 1:4
    temptable = DOCtable(ismember(DOCtable.cruise, cruises(season == categorical(theseasons(count)))) &  year(DOCtable.date) == sampling_yrs(yearct),:);
    if ~isempty(temptable)
    subplot(2,2,count)
    plot(temptable.latitude(temptable.depth < 6),temptable.npoc(temptable.depth < 6),'.-b','markersize',15)
    hold on
    plot(temptable.latitude(temptable.depth > 6 & temptable.depth < 70),temptable.npoc(temptable.depth > 6 & temptable.depth < 70),'.-g','markersize',15)
    plot(temptable.latitude(temptable.depth > 70 & temptable.depth < 110),temptable.npoc(temptable.depth > 70 & temptable.depth < 110),'.-r','markersize',15)
    plot(temptable.latitude(temptable.depth > 400),temptable.npoc(temptable.depth > 400),'.-k','markersize',15)
    plot(temptable.latitude(temptable.depth > 110 & temptable.depth < 400),temptable.npoc(temptable.depth > 110 & temptable.depth < 400),'.-m','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-b','markersize',15)
%     hold on
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),'.-g','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),'.-r','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),'.-k','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),'.-m','markersize',15)
    grid on
    axis([39.5 41.5 40 110])
    set(gca,'XDir','reverse')

    if ~isempty(temptable.latitude(temptable.depth > 110 & temptable.depth < 400))
        legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','southwest')
    else
        legend({'surface','6<D<70','70<D<110','>400m'},'location','southwest')
    end
    xlabel('Latitude','fontweight','bold')
    ylabel('DOC (uM)','fontweight','bold')
    title(['DOC by latitude, ' char(temptable.cruise(1)) ' - ' cell2mat(theseasons(count)) ' ' num2str(year(temptable.date(1)))])
    end
end
set(gcf,'position',[400 230 900 730])
print([p 'plots' filesep 'DOC_transect_lat_vs_DOC_per_season_grouped_depths_' num2str(sampling_yrs(yearct))], '-dpng')
end
%}

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
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-b','markersize',15)
%     hold on
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),'.-g','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),'.-r','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),'.-k','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),'.-m','markersize',15)
    grid on
    axis([39.5 41.5 40 110])
    set(gca,'XDir','reverse')

%     if ~isempty(temptable.latitude(temptable.depth > 110 & temptable.depth < 400))
%         legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','southwest')
%     else
%         legend({'surface','6<D<70','70<D<110','>400m'},'location','southwest')
%     end
%     xlabel('Latitude','fontweight','bold')
%     ylabel('DOC (uM)','fontweight','bold')
%     title(['DOC by lat, ' char(temptable.cruise(1)) ' - ' cell2mat(theseasons(count)) ' ' num2str(year(temptable.date(1)))])
    title([cell2mat(theseasons(count)) ' ' num2str(year(temptable.date(1))) ' - ' char(temptable.cruise(1))])
    end
end
filler = filler+4;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%for annual meeting plot
legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','southwest')
subplot(341); ylabel('DOC (uM)','fontweight','bold');
subplot(345); ylabel('DOC (uM)','fontweight','bold');
subplot(349); ylabel('DOC (uM)','fontweight','bold'); xlabel('Latitude','fontweight','bold')
subplot(346); xlabel('Latitude','fontweight','bold')
subplot(347); xlabel('Latitude','fontweight','bold')
subplot(348); xlabel('Latitude','fontweight','bold')
% set(gcf,'position',[400 230 900 730])
print([p 'plots' filesep 'DOC_transect_lat_vs_DOC_per_season_grouped_depths_all'], '-dpng')



%plot latitude TN lines colored by depth interval. 1 fig per yr.  4 seasons
for yearct = 1:length(sampling_yrs)
    figure
for count = 1:4
    temptable = DOCtable(ismember(DOCtable.cruise, cruises(season == categorical(theseasons(count)))) &  year(DOCtable.date) == sampling_yrs(yearct),:);
    if ~isempty(temptable)
    subplot(2,2,count)
    plot(temptable.latitude(temptable.depth < 6),temptable.tn(temptable.depth < 6),'.-b','markersize',15)
    hold on
    plot(temptable.latitude(temptable.depth > 6 & temptable.depth < 70),temptable.tn(temptable.depth > 6 & temptable.depth < 70),'.-g','markersize',15)
    plot(temptable.latitude(temptable.depth > 70 & temptable.depth < 110),temptable.tn(temptable.depth > 70 & temptable.depth < 110),'.-r','markersize',15)
    plot(temptable.latitude(temptable.depth > 400),temptable.tn(temptable.depth > 400),'.-k','markersize',15)
    plot(temptable.latitude(temptable.depth > 110 & temptable.depth < 400),temptable.tn(temptable.depth > 110 & temptable.depth < 400),'.-m','markersize',15)
    grid on
    axis([39.5 41.5 0 30])
    set(gca,'XDir','reverse')

    if ~isempty(temptable.latitude(temptable.depth > 110 & temptable.depth < 400))
        legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','northwest')
    else
        legend({'surface','6<D<70','70<D<110','>400m'},'location','northwest')
    end
    xlabel('Latitude','fontweight','bold')
    ylabel('TN (uM)','fontweight','bold')
    title(['TN by latitude, ' char(temptable.cruise(1)) ' - ' cell2mat(theseasons(count)) ' ' num2str(year(temptable.date(1)))])
    end
end
%save figure
set(gcf,'position',[400 230 900 730])
print([p 'plots' filesep 'TN_transect_lat_vs_TN_per_season_grouped_depths'], '-dpng')
end


figure
filler = 0;
for yearct = 1:length(sampling_yrs)
for count = 1:4
    temptable = DOCtable(ismember(DOCtable.season, season(count)) &  year(DOCtable.date) == sampling_yrs(yearct),:);
    if ~isempty(temptable)
    subplot(length(sampling_yrs),4,count+filler)
    plot(temptable.latitude(temptable.depth < 6),temptable.tn(temptable.depth < 6),'.-b','markersize',15)
    hold on
    plot(temptable.latitude(temptable.depth > 6 & temptable.depth < 70),temptable.tn(temptable.depth > 6 & temptable.depth < 70),'.-g','markersize',15)
    plot(temptable.latitude(temptable.depth > 70 & temptable.depth < 150),temptable.tn(temptable.depth > 70 & temptable.depth < 150),'.-r','markersize',15)
    plot(temptable.latitude(temptable.depth > 200),temptable.tn(temptable.depth > 200),'.-k','markersize',15)
    plot(temptable.latitude(temptable.depth > 150 & temptable.depth < 200),temptable.tn(temptable.depth > 150 & temptable.depth < 200),'.-m','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-b','markersize',15)
%     hold on
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),'.-g','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),'.-r','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),'.-k','markersize',15)
%     plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),'.-m','markersize',15)
    grid on
    axis([39.5 41.5 tnrange])
    set(gca,'XDir','reverse')

%     if ~isempty(temptable.latitude(temptable.depth > 110 & temptable.depth < 400))
%         legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','southwest')
%     else
%         legend({'surface','6<D<70','70<D<110','>400m'},'location','southwest')
%     end
%     xlabel('Latitude','fontweight','bold')
%     ylabel('DOC (uM)','fontweight','bold')
%     title(['DOC by lat, ' char(temptable.cruise(1)) ' - ' cell2mat(theseasons(count)) ' ' num2str(year(temptable.date(1)))])
    title([cell2mat(theseasons(count)) ' ' num2str(year(temptable.date(1))) ' - ' char(temptable.cruise(1))])
    end
end
filler = filler+4;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%for annual meeting plot
legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','southwest')
subplot(341); ylabel('DTN (uM)','fontweight','bold');
subplot(345); ylabel('DTN (uM)','fontweight','bold');
subplot(349); ylabel('DTN (uM)','fontweight','bold'); xlabel('Latitude','fontweight','bold')
subplot(346); xlabel('Latitude','fontweight','bold')
subplot(347); xlabel('Latitude','fontweight','bold')
subplot(348); xlabel('Latitude','fontweight','bold')
% set(gcf,'position',[400 230 900 730])
print([p 'plots' filesep 'DOC_transect_lat_vs_DOC_per_season_grouped_depths_all'], '-dpng')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%plot latitude DOC:TN lines colored by depth interval. 1 fig per yr.  4 seasocleans
for yearct = 1:length(sampling_yrs)
    figure
for count = 1:4
    temptable = DOCtable(ismember(DOCtable.cruise, cruises(season == categorical(theseasons(count)))) &  year(DOCtable.date) == sampling_yrs(yearct),:);
    if ~isempty(temptable)
    temptable.ratio = temptable.npoc./temptable.tn;
    subplot(2,2,count)
    plot(temptable.latitude(temptable.depth < 6),temptable.ratio(temptable.depth < 6),'.-b','markersize',15)
    hold on
    plot(temptable.latitude(temptable.depth > 6 & temptable.depth < 70),temptable.ratio(temptable.depth > 6 & temptable.depth < 70),'.-g','markersize',15)
    plot(temptable.latitude(temptable.depth > 70 & temptable.depth < 110),temptable.ratio(temptable.depth > 70 & temptable.depth < 110),'.-r','markersize',15)
    plot(temptable.latitude(temptable.depth > 400),temptable.ratio(temptable.depth > 400),'.-k','markersize',15)
    plot(temptable.latitude(temptable.depth > 110 & temptable.depth < 400),temptable.ratio(temptable.depth > 110 & temptable.depth < 400),'.-m','markersize',15)
    grid on
    axis([39.5 41.5 0 30])
    set(gca,'XDir','reverse')

    if ~isempty(temptable.latitude(temptable.depth > 110 & temptable.depth < 400))
        legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','northwest')
    else
        legend({'surface','6<D<70','70<D<110','>400m'},'location','northwest')
    end
    xlabel('Latitude','fontweight','bold')
    ylabel('Molar Ratio DOC:TN','fontweight','bold')
    title(['DOC:TN by latitude, ' char(temptable.cruise(1)) ' - ' cell2mat(theseasons(count)) ' ' num2str(year(temptable.date(1)))])
    end
end
%save figure
set(gcf,'position',[400 230 900 730])
print([p 'plots' filesep 'CtoNratio_transect_lat_vs_ratio_per_season_grouped_depths_' num2str(sampling_yrs(yearct))], '-dpng')
end


%TN vs DOC colored by season, symbol by depth grouping
figure
tint = 'bgrk';
for count = 1:length(theseasons)
%     subplot(2,2,count)
    plot(DOCtable.tn(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth < 6),DOCtable.npoc(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth < 6),'color',tint(count),'Marker','.','LineStyle','none','markersize',15)
    hold on
    plot(DOCtable.tn(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth > 6 & DOCtable.depth < 70),DOCtable.npoc(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth > 6 & DOCtable.depth < 70),'color',tint(count),'Marker','+','LineStyle','none','markersize',10)
    plot(DOCtable.tn(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth > 70 & DOCtable.depth < 110),DOCtable.npoc(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth > 70 & DOCtable.depth < 110),'color',tint(count),'Marker','^','LineStyle','none','markersize',10)
    plot(DOCtable.tn(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth > 110 & DOCtable.depth < 400),DOCtable.npoc(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth > 110 & DOCtable.depth < 400),'color',tint(count),'Marker','*','LineStyle','none','markersize',10)
    plot(DOCtable.tn(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth > 400),DOCtable.npoc(ismember(DOCtable.cruise,cruises(season == categorical(theseasons(count)))) & DOCtable.depth > 400),'color',tint(count),'Marker','x','LineStyle','none','markersize',10)
    grid on
    set(gca,'ylim',docrange)
    legend({'surface','6<D<70','70<D<110','110<D<400','>400m'},'location','northeast')
    xlabel('TN (uM)','fontweight','bold')
    ylabel('DOC (uM)','fontweight','bold')
%     title(['DOC by latitude, ' cell2mat(cruises(count)) ' - ' cell2mat(cruise_season(count))])
    title(['DOC by latitude in ' cell2mat(upper(theseasons(count))) ' on ' cell2mat(cruises(season == categorical(theseasons(count))))])
%     title(['DOC across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
end
%save figure
set(gcf,'position',[400 230 900 730])
print([p 'plots' filesep 'TNvsDOC_by_season_grouped_depths'], '-dpng')

%Surface DOC across latitude per cruise
figure
hold on
for count = 1:length(cruises)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-','markersize',15)
end
grid on
set(gca,'XDir','reverse')
legend(cruises,'location','southwest')
xlabel('Latitude','fontweight','bold')
ylabel('DOC (uM)','fontweight','bold')
title(['Surface DOC across NESLTER transect'])
%save figure
set(gcf,'position',[450 330 850 430])
print([p 'plots' filesep 'DOC_transect_SURFACE_lat_vs_DOC_grouped_cruises'], '-dpng')

%Surface TN across latitutde per cruise
figure
hold on
for count = 1:length(cruises)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.tn(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-','markersize',15)
end
grid on
set(gca,'XDir','reverse')
legend(cruises,'location','northwest')
xlabel('Latitude','fontweight','bold')
ylabel('TN (uM)','fontweight','bold')
title('Surface TN across NESLTER transect on 3 different cruises')
%save figure
set(gcf,'position',[450 330 850 430])
print([p 'plots' filesep 'TN_transect_SURFACE_lat_vs_TN_grouped_cruises'], '-dpng')

%Surface DOC:TN ratio across latitutde per cruise
figure
hold on
for count = 1:length(cruises)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.npoc(DOCtable.cruise == cruises(count) & DOCtable.depth < 6)./DOCtable.tn(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-','markersize',15)
end
grid on
set(gca,'XDir','reverse')
legend(cruises,'location','northwest')
xlabel('Latitude','fontweight','bold')
ylabel('DOC:TN ratio','fontweight','bold')
title('Surface DOC:TN ratio across NESLTER transect')
%save figure
set(gcf,'position',[450 330 850 430])
print([p 'plots' filesep 'CtoNratio_transect_SURFACE_lat_vs_TN_grouped_cruises'], '-dpng')

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
figure
hold on
for count = 1:length(cruises)
    ind = find(DOCtable.cruise == cruises(count) & DOCtable.depth < 6);
    plot(DOCtable.latitude(ind),DOCtable.npoc(ind)./DOCtable.tn(ind),'.-','markersize',15)
end
grid on
set(gca,'XDir','reverse')
legend(cruises,'location','northwest')
xlabel('Latitude','fontweight','bold')
ylabel('DOC:TN','fontweight','bold')
title('Surface DOC:TN ratio across NESLTER transect')
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
figure
hold on
for count = 1:length(cruises)
    ind = find(DOCtable.cruise == cruises(count));
%     ind = find(DOCtable.cruise == cruises(count) & DOCtable.depth < 6);
    plot(DOCtable.tn(ind),DOCtable.npoc(ind),'.','markersize',15)
end
grid on
% set(gca,'XDir','reverse')
legend(cruises,'location','northwest')
xlabel('TN','fontweight','bold')
ylabel('DOC','fontweight','bold')
title('TN across NESLTER transect')
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
figure
hold on
for count = 1:length(cruises)
    ind = find(DOCtable.cruise == cruises(count));
%     ind = find(DOCtable.cruise == cruises(count) & DOCtable.depth < 6);
    plot(DOCtable.npoc(ind)./DOCtable.tn(ind),DOCtable.depth(ind),'.','markersize',15)
end
grid on
set(gca,'YDir','reverse')
legend(cruises,'location','northwest')
xlabel('DOC:TN','fontweight','bold')
ylabel('Depth','fontweight','bold')
title('C:N ratio across NESLTER transect')
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


figure
for count = 1:length(cruises)
%     figure
    subplot(2,2,count)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.tn(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-b','markersize',15)
    hold on
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),DOCtable.tn(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),'.-g','markersize',15)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),DOCtable.tn(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),'.-r','markersize',15)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),DOCtable.tn(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),'.-k','markersize',15)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),DOCtable.tn(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),'.-m','markersize',15)
    grid on
    set(gca,'XDir','reverse')
    set(gca,'ylim',tnrange)

    if ~isempty(DOCtable.latitude(DOCtable.cruise == 'EN687' & DOCtable.depth > 110 & DOCtable.depth < 400))
        legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','northwest')
    else
        legend({'surface','6<D<70','70<D<110','>400m'},'location','northwest')
    %     legend('surface','chl max','90m','500m')
    end
    xlabel('Latitude','fontweight','bold')
    ylabel('Total Nitrogen (uM)','fontweight','bold')
    title(['Total NITROGEN by latitude, ' cell2mat(cruises(count)) ' - ' cell2mat(cruise_season(count))])
%     title(['DOC across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
end
set(gcf,'position',[400 230 900 730])
print([p 'plots' filesep 'TN_transect_lat_vs_TN_per_season_grouped_depths'], '-dpng')


% figure
% hold on
% for count = 1:length(cruises)
%     scatter(doc.latitude(doc.cruise == cruises(count)),doc.depth(doc.cruise == cruises(count)),[],doc.npocum(doc.cruise == cruises(count)),'filled');
% end
% grid on
% set(gca,'XDir','reverse')
% set(gca,'YDir','reverse')
% legend(cruises)
% ylabel('Depth (m)','fontweight','bold')
% xlabel('Latitude','fontweight','bold')
% colorbar
% c = colorbar;
% set(c,'lim',docrange)
% title(['Surface DOC across NESLTER transect on 3 different cruises'])