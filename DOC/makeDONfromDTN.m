%DTN needs minus inorganic N (ammoniumm and nitrate + nitrite) to find DON
load \\sosiknas1\Lab_data\LTER\DOC\DOCtable.mat


nut = readtable('\\sosiknas1\Lab_data\LTER\NUT\API_products\nut_data_all.csv');
DOCtable.nh4(:) = nan;
DOCtable.no3no2(:) = nan;
for count = 1:size(DOCtable)
    ind = find(nut.cruise == DOCtable.cruise(count) & nut.cast == DOCtable.cast(count) & nut.niskin == DOCtable.niskin(count));
    if ~isempty(ind)
    temp = [nanmean(nut.ammonium(ind)) nanmean(nut.nitrate_nitrite(ind))];
    temp(temp == 0) = 0.001;
    DOCtable.nh4(count) = temp(1);
    DOCtable.no3no2(count) = temp(2);
    end
end

DOCtable.don = DOCtable.tn - (DOCtable.nh4 + DOCtable.no3no2);
donrange = [0 8];

%DOC TS by season
figure
for count = 1:4
subplot(2,2,count)
    ind = find(DOCtable.season == season(count));
    scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc,'filled');
    grid on; colorbar; axis([saltrange temprange]); clim([10 25]); %caxis([10 25]);
    ylabel('Temperature','fontweight','bold'); xlabel('Salinity','fontweight','bold'); title(['DOC ' char(season(count))]);
end

%DON TS by season
figure
for count = 1:4
subplot(2,2,count)
    ind = find(DOCtable.season == season(count));
scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.don(ind),'filled');
grid on; colorbar; axis([saltrange temprange]); clim(donrange); %caxis([10 25]);
ylabel('Temperature','fontweight','bold'); xlabel('Salinity','fontweight','bold'); title(['DON ' char(season(count))]);
end

%DOC:DON ratio TS by season
figure
for count = 1:4
subplot(2,2,count)
    ind = find(DOCtable.season == season(count));
    scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc(ind)./DOCtable.don(ind),'filled');
    grid on; colorbar; axis([saltrange temprange]); clim([5 15]); %caxis([10 25]);
    ylabel('Temperature','fontweight','bold'); xlabel('Salinity','fontweight','bold'); title(['DOC:DON ratio ' char(season(count))]);
end


%DOC:DON ratio latitude and depth by season
figure
for count = 1:4
subplot(2,2,count)
    ind = find(DOCtable.season == season(count));
    scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.npoc(ind)./DOCtable.don(ind),'filled');
    grid on; colorbar; clim([10 25]);
    set(gca, 'XDir','reverse'); set(gca, 'YDir','reverse')
    ylabel('Depth (m)','fontweight','bold'); xlabel('Latitude','fontweight','bold'); title(['DOC:DON ratio ' char(season(count))]);
end
