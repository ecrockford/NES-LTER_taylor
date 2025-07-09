%Taylor 10/5/2022
%just playing around with initial DOC data to see initial results
%do they make sense? how'd our diff sampling strategies fair?

% load \\sosiknas1\Lab_data\LTER\DOC\DOCtable.mat
p = '\\sosiknas1\Lab_data\LTER\DOC\';
DOCtable = readtable([p 'nes-lter-doc-transect.csv']);

%get rid of blanks
DOCtable.cast_type = categorical(DOCtable.cast_type);
DOCtable = DOCtable(DOCtable.cast_type == 'C',:);

%for now just work with the 3 cruises we have. Manually make list so
%they're in seasonal water. When doing unique(doc.cruises) they come out in
%alphabetical order which puts spring first
cruises = {'AT46','AR66B','EN687'};
cruise_season = {'Winter 2022','Spring 2022','Summer 2022'};

%on 10/5/22 for the 3 cruises, true range is 44.4-93.19
docrange = [45 95];

figure
for count = 1:length(cruises)
    subplot(3,1,count)
    scatter(DOCtable.latitude(DOCtable.cruise == cruises(count)),DOCtable.depth(DOCtable.cruise == cruises(count)),[],DOCtable.npocum(DOCtable.cruise == cruises(count)),'filled');
    title(['DOC by depth across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
    grid on
    set(gca, 'YDir','reverse')
    ylim([0 150]) %only L11 500m samples deeper than 110, can't really see range when everythign scrunched at surf
%     ylim([0 510]) %some of samples slightly deeper than 500m, 502 is max but want to be able to see dot ok
    set(gca, 'XDir','reverse')
    xlim([39.70 41.2])
    ylabel('Depth (m)','fontweight','bold')
    xlabel('Latitude','fontweight','bold')
    colorbar
    c = colorbar;
    set(c,'lim',docrange)
end

%sort list by latitude to easily plot .- and have not go every which way
[b,ind] = sort(DOCtable.latitude);
DOCtable = DOCtable(ind,:);
docrange = [40 95]; %reset doc range to see on yaxis, previously was set for colorbar

figure
for count = 1:length(cruises)
%     figure
    subplot(2,2,count)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.npocum(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-b','markersize',15)
    hold on
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),DOCtable.npocum(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),'.-g','markersize',15)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),DOCtable.npocum(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),'.-r','markersize',15)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),DOCtable.npocum(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),'.-k','markersize',15)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),DOCtable.npocum(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),'.-m','markersize',15)
    grid on
    set(gca,'XDir','reverse')
    set(gca,'ylim',docrange)

    if ~isempty(DOCtable.latitude(DOCtable.cruise == 'EN687' & DOCtable.depth > 110 & DOCtable.depth < 400))
        legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','southwest')
    else
        legend({'surface','6<D<70','70<D<110','>400m'},'location','southwest')
    %     legend('surface','chl max','90m','500m')
    end
    xlabel('Latitude','fontweight','bold')
    ylabel('DOC (uM)','fontweight','bold')
    title(['DOC by latitude, ' cell2mat(cruises(count)) ' - ' cell2mat(cruise_season(count))])
%     title(['DOC across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
end

figure
hold on
for count = 1:length(cruises)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.npocum(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-','markersize',15)
end
grid on
set(gca,'XDir','reverse')
legend(cruises)
xlabel('Latitude','fontweight','bold')
ylabel('DOC (uM)','fontweight','bold')
title(['Surface DOC across NESLTER transect on 3 different cruises'])

figure
hold on
for count = 1:length(cruises)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.tnum(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-','markersize',15)
end
grid on
set(gca,'XDir','reverse')
legend(cruises)
xlabel('Latitude','fontweight','bold')
ylabel('TN (uM)','fontweight','bold')
title('Surface TN across NESLTER transect on 3 different cruises')

tnrange = [3 27];
figure
for count = 1:length(cruises)
%     figure
    subplot(2,2,count)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),DOCtable.tnum(DOCtable.cruise == cruises(count) & DOCtable.depth < 6),'.-b','markersize',15)
    hold on
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),DOCtable.tnum(DOCtable.cruise == cruises(count) & DOCtable.depth > 6 & DOCtable.depth < 70),'.-g','markersize',15)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),DOCtable.tnum(DOCtable.cruise == cruises(count) & DOCtable.depth > 70 & DOCtable.depth < 110),'.-r','markersize',15)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),DOCtable.tnum(DOCtable.cruise == cruises(count) & DOCtable.depth > 400),'.-k','markersize',15)
    plot(DOCtable.latitude(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),DOCtable.tnum(DOCtable.cruise == cruises(count) & DOCtable.depth > 110 & DOCtable.depth < 400),'.-m','markersize',15)
    grid on
    set(gca,'XDir','reverse')
    set(gca,'ylim',tnrange)

    if ~isempty(DOCtable.latitude(DOCtable.cruise == 'EN687' & DOCtable.depth > 110 & DOCtable.depth < 400))
        legend({'surface','6<D<70','70<D<110','>400m','110<D<400'},'location','southwest')
    else
        legend({'surface','6<D<70','70<D<110','>400m'},'location','northwest')
    %     legend('surface','chl max','90m','500m')
    end
    xlabel('Latitude','fontweight','bold')
    ylabel('Total Nitrogen (uM)','fontweight','bold')
    title(['Total NITROGEN by latitude, ' cell2mat(cruises(count)) ' - ' cell2mat(cruise_season(count))])
%     title(['DOC across NESLTER transect on ' cell2mat(cruises(count)) ', ' cell2mat(cruise_season(count))])
end


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