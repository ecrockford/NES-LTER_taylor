
% p = 'C:\work\LTER\POC\';
p = '\\sosiknas1\Lab_data\LTER\CHN\';
load([p 'NESLTER_CHN_table'])
[y,m,d] = datevec(CHNtable.datetime);
CHNtable.sample_year = y;
CHNtable.sample_month = m;
CHNtable.yearday = round(datenum(CHNtable.datetime)-datenum(y,1,0));
% CHNtable.yearday = round(CHNtable.datetime-datenum(y,1,0));
clear y m d

CHNtable.PON_umolperL(CHNtable.PON_umolperL == 0) = 0.01;
avg_ratio = nanmean(CHNtable.C_to_N_molar_ratio(CHNtable.C_to_N_molar_ratio <15));
CHNtable.anomaly_ratio = CHNtable.C_to_N_molar_ratio - avg_ratio;
% subset out surface to just plot that
surface = CHNtable(CHNtable.depth < 6,:);
avg_surf_ratio = nanmean(surface.C_to_N_molar_ratio(surface.C_to_N_molar_ratio <15));
surface.anomaly_ratio = surface.C_to_N_molar_ratio - avg_ratio;
nonsurface = CHNtable(CHNtable.depth > 6,:);
avg_nonsurf_ratio = nanmean(nonsurface.C_to_N_molar_ratio(nonsurface.C_to_N_molar_ratio <15));
nonsurface.anomaly_ratio = nonsurface.C_to_N_molar_ratio - avg_ratio;

%%% PLOT RATIO ANOMALY FOR ENTIRE DATA SET AND THEN FOR SURFACE ONLY
figure
subplot(311)
plot(CHNtable.datetime(CHNtable.anomaly_ratio > 0),CHNtable.anomaly_ratio(CHNtable.anomaly_ratio > 0),'b.','markersize',8)
hold on;
plot(CHNtable.datetime(CHNtable.anomaly_ratio < 0),CHNtable.anomaly_ratio(CHNtable.anomaly_ratio < 0),'r.','markersize',8)
ylim([-6 6]); grid on; datetick('x');
xlabel('Date','fontweight','bold'); ylabel('C:N molar ratio anomaly','fontweight','bold');
title('NESLTER transect ALL - POC : PON ratio anomoly over time')
subplot(312)
plot(surface.datetime(surface.anomaly_ratio > 0),surface.anomaly_ratio(surface.anomaly_ratio > 0),'b.','markersize',8)
hold on
plot(surface.datetime(surface.anomaly_ratio < 0),surface.anomaly_ratio(surface.anomaly_ratio < 0),'r.','markersize',8)
ylim([-6 6]); grid on; datetick('x');
xlabel('Date','fontweight','bold'); ylabel('C:N molar ratio anomaly','fontweight','bold');
title('NESLTER transect Surface POC : PON ratio anomoly over time')
subplot(313)
plot(nonsurface.datetime(nonsurface.anomaly_ratio > 0),nonsurface.anomaly_ratio(nonsurface.anomaly_ratio > 0),'b.','markersize',8)
hold on
plot(nonsurface.datetime(nonsurface.anomaly_ratio < 0),nonsurface.anomaly_ratio(nonsurface.anomaly_ratio < 0),'r.','markersize',8)
ylim([-6 6]); grid on; datetick('x');
xlabel('Date','fontweight','bold'); ylabel('C:N molar ratio anomaly','fontweight','bold');
title('NESLTER transect NON-Surface POC : PON ratio anomoly over time')
%%%

%RATIO all points by sample count
%{
figure
plot(CHNtable.C_to_N_molar_ratio,'.-','MarkerSize',12)
hold on
indB11 = find(categorical(CHNtable.CHNBlank) == 'B11');
plot(indB11,CHNtable.C_to_N_molar_ratio(indB11),'r*','markersize',10)
indB13 = find(categorical(CHNtable.CHNBlank) == 'B13');
plot(indB13,CHNtable.C_to_N_molar_ratio(indB13),'g*','markersize',10)
line([0 size(CHNtable,1)],[avg_ratio avg_ratio],'color','k','linestyle','--','linewidth',2)
ylim([0 15])
grid on
xlabel('Sample Count','FontWeight','bold');
ylabel('Molar Ratio C:N','FontWeight','bold');
title('all NESLTER transect POC : PON ratio by sample count')
legend('all',['B11=' num2str(CHNtable.blankC(indB11(1)))],['B13=' num2str(CHNtable.blankC(indB13(1)))],'mean ratio','location','best')
%}

%RATIO at surface by sample count
%{
figure
plot(surface.C_to_N_molar_ratio,'.-','MarkerSize',12)
hold on
indB11 = find(categorical(surface.CHNBlank) == 'B11');
plot(indB11,surface.C_to_N_molar_ratio(indB11),'r*','markersize',10)
indB13 = find(categorical(surface.CHNBlank) == 'B13');
plot(indB13,surface.C_to_N_molar_ratio(indB13),'g*','markersize',10)
line([0 size(surface,1)],[avg_surf_ratio avg_surf_ratio],'color','k','linestyle','--','linewidth',2)
ylim([0 15])
grid on
xlabel('Sample Count','FontWeight','bold');
ylabel('Molar Ratio C:N','FontWeight','bold');
title('Surface POC : PON ratio by sample count')
legend('all',['B11=' num2str(surface.blankC(indB11(1)))],['B13=' num2str(surface.blankC(indB13(1)))],'mean ratio','location','best')
%}

%RATIO at surface by date
figure
plot(surface.datetime,surface.C_to_N_molar_ratio,'.','MarkerSize',12)
hold on
% indB11 = find(categorical(surface.CHNBlank) == 'B11');
% plot(surface.datetime(indB11),surface.C_to_N_molar_ratio(indB11),'r*','markersize',10)
% indB13 = find(categorical(surface.CHNBlank) == 'B13');
% plot(surface.datetime(indB13),surface.C_to_N_molar_ratio(indB13),'g*','markersize',10)
line([min(surface.datetime) max(surface.datetime)],[avg_surf_ratio avg_surf_ratio],'color','k','linestyle','--','linewidth',2)
ylim([0 15])
grid on
xlabel('Date','FontWeight','bold');
datetick('x')
ylabel('Molar Ratio C:N','FontWeight','bold');
title('Surface POC : PON ratio over time')
grid on;
legend('all','mean ratio','location','best')
% legend('all',['B11=' num2str(surface.blankC(indB11(1)))],['B13=' num2str(surface.blankC(indB13(1)))],'mean ratio','location','best')

%CARBON at surface by date
avg_surf_POCuM = nanmean(surface.POC_umolperL); %(surface.C_to_N_molar_ratio <15));
avg_surf_PONuM = nanmean(surface.PON_umolperL); %(surface.C_to_N_molar_ratio <15));
avg_surf_POCugL = nanmean(surface.POC_ugperL); %(surface.C_to_N_molar_ratio <15));
avg_surf_PONugL = nanmean(surface.PON_ugperL); %(surface.C_to_N_molar_ratio <15));

figure
subplot(3,1,1);
plot(surface.datetime,surface.POC_ugperL,'.','MarkerSize',12)
hold on
line([min(surface.datetime) max(surface.datetime)],[avg_surf_POCugL avg_surf_POCugL],'color','k','linestyle','--','linewidth',1)
% ylim([0 15])
xlabel('Date','FontWeight','bold'); datetick('x')
ylabel('POC (ug/L)','FontWeight','bold');
title('NESLTER transect Surface POC (ug/L) over time')
grid on;
legend('all','mean POC','location','best')

subplot(3,1,2);
plot(surface.datetime,surface.PON_ugperL,'.','MarkerSize',12)
hold on
line([min(surface.datetime) max(surface.datetime)],[avg_surf_PONugL avg_surf_PONugL],'color','k','linestyle','--','linewidth',1)
% ylim([0 15])
xlabel('Date','FontWeight','bold'); datetick('x')
ylabel('PON (ug/L)','FontWeight','bold');
title('NESLTER transect Surface PON(ug/L) over time')
grid on;
legend('all','mean PON','location','best')

subplot(3,1,3);
plot(surface.datetime,surface.C_to_N_molar_ratio,'.','MarkerSize',12)
hold on
line([min(surface.datetime) max(surface.datetime)],[avg_surf_ratio avg_surf_ratio],'color','k','linestyle','--','linewidth',2)
grid on; ylim([0 15])
xlabel('Date','FontWeight','bold'); datetick('x'); ylabel('Molar Ratio C:N','FontWeight','bold');
title('NESLTER transect Surface POC : PON ratio over time')
legend('all','mean ratio','location','best')

%%BY YEARDAY
figure
subplot(3,1,1);
plot(surface.yearday,surface.POC_ugperL,'.','MarkerSize',10)
hold on
line([1 365],[avg_surf_POCugL avg_surf_POCugL],'color','k','linestyle','--','linewidth',1);
% ylim([0 15])
xlabel('Year Day','FontWeight','bold'); datetick('x')
ylabel('POC (ug/L)','FontWeight','bold');
title('NESLTER transect Surface POC (ug/L)')
grid on;
legend('all','mean POC','location','best')

subplot(3,1,2);
plot(surface.yearday,surface.PON_ugperL,'.','MarkerSize',10)
hold on
line([1 365],[avg_surf_PONugL avg_surf_PONugL],'color','k','linestyle','--','linewidth',1)
% ylim([0 15])
xlabel('Date','FontWeight','bold'); datetick('x')
ylabel('PON (ug/L)','FontWeight','bold');
title('NESLTER transect Surface PON(ug/L)')
grid on;
legend('all','mean PON','location','best')

subplot(3,1,3);
plot(surface.yearday,surface.C_to_N_molar_ratio,'.','MarkerSize',10)
hold on
line([1 365],[avg_surf_ratio avg_surf_ratio],'color','k','linestyle','--','linewidth',2)
grid on; ylim([0 15])
xlabel('Date','FontWeight','bold'); datetick('x'); ylabel('Molar Ratio C:N','FontWeight','bold');
title('NESLTER transect Surface POC : PON ratio')
legend('all','mean ratio','location','best')


%BY LATITUDE - RATIO at surface by date
figure
plot(surface.latitude,surface.C_to_N_molar_ratio,'.','MarkerSize',12)
hold on
% ylim([0 15])
xlim([39.70 41.2])
grid on
xlabel('Latitude','FontWeight','bold'); ylabel('Molar Ratio C:N','FontWeight','bold');
title('Surface POC : PON by latitude')


%%%%%%%%%%%%%%%%%%COPY AND PASTE FROM DOC PLOTTING NEEDS UPDATING FOR POC
%on 10/5/22 for the 3 cruises, true range is 44.4-93.19
% docrange = [45 95];

CHNtable.cruise = categorical(CHNtable.cruise);
unq_cruise = unique(CHNtable.cruise);
% save_location = 'C:\Users\Taylor\Desktop\work\CHN\';
save_location = '\\sosiknas1\Lab_data\LTER\CHN\plots\';
for count = 1:length(unq_cruise)
    colorC_range=[0 400];
    colorN_range=[0 80];
    colorRatio_range=[0 10];
%     colorC_range=[0 250]; %for AT46
%     colorN_range=[0 60]; %for AT46
%     colorRatio_range=[0 10]; %for AT46

    figure
    subplot(3,1,1)
    scatter(CHNtable.latitude(CHNtable.cruise == unq_cruise(count)),CHNtable.depth(CHNtable.cruise == unq_cruise(count)),[],CHNtable.POC_ugperL(CHNtable.cruise == unq_cruise(count)),'filled');
    title(['POC on NESLTER transect cruise ' char(unq_cruise(count))]) % ', ' cell2mat(cruise_season(count))])
    xlim([39.70 41.2]); ylim([0 100]); 
    grid on
    set(gca, 'YDir','reverse'); set(gca, 'XDir','reverse');
    ylabel('Depth (m)','fontweight','bold'); %xlabel('Latitude','fontweight','bold');
    text(41.1,90,'POC (ug/L)') 
    c = colorbar;
    set(c,'Limits',colorC_range)
    clim(colorC_range)
%     set(gcf,'Position',[385 150 615 258])
    hold on
    plot(CHNtable.latitude(CHNtable.cruise == unq_cruise(count) & CHNtable.C_quality_flag > 2),CHNtable.depth(CHNtable.cruise == unq_cruise(count) & CHNtable.C_quality_flag > 2),'ro','markersize',9)

        subplot(3,1,2)
%     figure
    scatter(CHNtable.latitude(CHNtable.cruise == unq_cruise(count)),CHNtable.depth(CHNtable.cruise == unq_cruise(count)),[],CHNtable.PON_ugperL(CHNtable.cruise == unq_cruise(count)),'filled');
    title(['PON on NESLTER transect cruise ' char(unq_cruise(count))]) % ', ' cell2mat(cruise_season(count))])
    xlim([39.70 41.2]); ylim([0 100]); 
    grid on
    set(gca, 'YDir','reverse'); set(gca, 'XDir','reverse');
    ylabel('Depth (m)','fontweight','bold'); %xlabel('Latitude','fontweight','bold');
    text(41.1,90,'PON (ug/L)') 
    c = colorbar;
    set(c,'Limits',colorN_range)
    clim(colorN_range)
%     set(gcf,'Position',[385 150 615 258])
    hold on
    plot(CHNtable.latitude(CHNtable.cruise == unq_cruise(count) & CHNtable.N_quality_flag > 2),CHNtable.depth(CHNtable.cruise == unq_cruise(count) & CHNtable.N_quality_flag > 2),'ro','markersize',9)

    subplot(3,1,3)
%     figure
    scatter(CHNtable.latitude(CHNtable.cruise == unq_cruise(count)),CHNtable.depth(CHNtable.cruise == unq_cruise(count)),[],CHNtable.C_to_N_molar_ratio(CHNtable.cruise == unq_cruise(count)),'filled');
    title(['POC:PON Molar Matio on NESLTER transect cruise ' char(unq_cruise(count))]) % ', ' cell2mat(cruise_season(count))])
    xlim([39.70 41.2]); ylim([0 100]); 
    grid on
    set(gca, 'YDir','reverse'); set(gca, 'XDir','reverse');
    ylabel('Depth (m)','fontweight','bold'); xlabel('Latitude','fontweight','bold');
    text(41.1,90,'POC:PON molar ratio') 
    c = colorbar;
    set(c,'Limits',colorRatio_range)
    clim(colorRatio_range)
%     set(gcf,'Position',[385 150 615 258])
    hold on
    plot(CHNtable.latitude(CHNtable.cruise == unq_cruise(count) & CHNtable.N_quality_flag > 2),CHNtable.depth(CHNtable.cruise == unq_cruise(count) & CHNtable.N_quality_flag > 2),'ro','markersize',9)
    
    set(gcf, 'position', [488 41.8 560 740.8])
    saveas(gcf,[save_location char(unq_cruise(count)) '_POCPONratiolatitudedepth_plot.png'])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%for QC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
plot(CHNtable.PON_umolperL,CHNtable.POC_umolperL,'.','markersize',10)
grid on
xlabel('PON - micromolar','FontWeight','bold');
ylabel('POC - micromolar','fontweight','bold')
title('PON : POC - all NESLTER samples - all depths')
hold on
ind = find(CHNtable.N_quality_flag == 3);
plot(CHNtable.PON_umolperL(ind),CHNtable.POC_umolperL(ind),'g*','markersize',10)
ind = find(~isnan(CHNtable.PON_umolperL));
n = fit(CHNtable.PON_umolperL(ind),CHNtable.POC_umolperL(ind), 'poly1');
plot(n,CHNtable.PON_umolperL, CHNtable.POC_umolperL)



cruise2look = 'HRS2303';
cruise = CHNtable(categorical(CHNtable.cruise) == cruise2look,:);
indc = find(cruise.PON_umolperL == 0.01 & cruise.POC_umolperL >5);

%by latitude
figure
subplot 211
plot(cruise.latitude,cruise.POC_umolperL,'.','markersize',12)
hold on
plot(cruise.latitude(indc),cruise.POC_umolperL(indc),'ro','markersize',10)
grid on
ylabel('POC - micromolar','fontweight','bold')
xlabel('Latitude','fontweight','bold')
set(gca, 'XDir','reverse')
title([cruise2look ' POC by Latitude - all'])
subplot 212
plot(cruise.latitude,cruise.PON_umolperL,'.','markersize',12)
hold on
plot(cruise.latitude(indc),cruise.PON_umolperL(indc),'ro','markersize',10)
grid on
ylabel('PON - micromolar','fontweight','bold')
xlabel('Latitude','fontweight','bold')
set(gca, 'XDir','reverse')
title([cruise2look ' PON by Latitude - all'])
legend('all','suspect')

%by depth
figure
subplot 131
plot(cruise.POC_umolperL,cruise.depth,'.','markersize',12)
hold on
plot(cruise.POC_umolperL(indc),cruise.depth(indc),'ro','markersize',10)
set(gca, 'YDir','reverse')
title([cruise2look ' POC - all'])
xlabel('POC - micromolar','fontweight','bold')
ylabel('Depth (m)','fontweight','bold')
grid on
subplot 132
plot(cruise.PON_umolperL,cruise.depth,'.','markersize',12)
hold on
plot(cruise.PON_umolperL(indc),cruise.depth(indc),'ro','markersize',10)
set(gca, 'YDir','reverse')
grid on
xlabel('PON - micromolar','fontweight','bold')
ylabel('Depth (m)','fontweight','bold')
title([cruise2look ' PON - all'])
subplot 133
plot(cruise.C_to_N_molar_ratio,cruise.depth,'.','markersize',12)
hold on
plot(cruise.C_to_N_molar_ratio(indc),cruise.depth(indc),'ro','markersize',10)
set(gca, 'YDir','reverse')
grid on
xlabel('C:N molar ratio','fontweight','bold')
ylabel('Depth (m)','fontweight','bold')
title([cruise2look ' C:N ratio - all'])
