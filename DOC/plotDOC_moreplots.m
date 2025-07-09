%Taylor 10/5/2022
%just playing around with initial DOC data to see initial results
%do they make sense? how'd our diff sampling strategies fair?

load \\sosiknas1\Lab_data\LTER\DOC\DOCtable.mat

%{
%Plot by season all cruises per season. Fig for each 
figure
subplot 221 %winter
    ind = find(DOCtable.cruise == 'AT46');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.npoc(ind),'filled');
    hold on
    ind = find(DOCtable.cruise == 'EN695');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.npoc(ind),'filled','^');
    ind = find(DOCtable.cruise == 'EN712');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.npoc(ind),'filled','square');
    grid on; colorbar; axis([temprange saltrange]);
    flagged = find(DOCtable.quality_flag_c >1 & ismember(DOCtable.cruise,{'AT46','EN695','EN712'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title('Winter DOC')
    caxis(docrange)
%     clim(docrange)
    legend('AT46','EN695','EN712','flag')
subplot 222 %spring
    ind = find(DOCtable.cruise == 'AR66B');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.npoc(ind),'filled');
    hold on
    ind = find(DOCtable.cruise == 'HRS2303');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.npoc(ind),'filled','^');
    flagged = find(DOCtable.quality_flag_c >1 & ismember(DOCtable.cruise,{'AR66B','HRS2303'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    grid on; colorbar; axis([temprange saltrange]);
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title('Spring DOC')
    caxis(docrange)
%     clim(docrange)
    legend('AR66B','HRS2303','flag')
subplot 223 %Summer
    ind = find(DOCtable.cruise == 'EN687');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.npoc(ind),'filled');
    hold on
    ind = find(DOCtable.cruise == 'EN706');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.npoc(ind),'filled','^');
    flagged = find(DOCtable.quality_flag_c >1 & ismember(DOCtable.cruise,{'EN687','EN706'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    grid on; colorbar; axis([temprange saltrange]);
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title('Summer DOC')
    caxis(docrange)
%     clim(docrange)
    legend('EN687','EN706','flag')
subplot 224 %Fall
    ind = find(DOCtable.cruise == 'AR77');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.npoc(ind),'filled','^');
    hold on
%     ind = find(DOCtable.cruise == 'EN695');
%     scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled','*');
    grid on; colorbar; axis([temprange saltrange]);
    flagged = find(DOCtable.quality_flag_c >1 & ismember(DOCtable.cruise,{'AR77'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title('Fall DOC')
    caxis(docrange)
%     clim(docrange)
    legend('AR77','flag')


%NITROGEN Plot by season all cruises per season. Fig for each 
figure
subplot 221 %winter
    ind = find(DOCtable.cruise == 'AT46');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled');
    hold on
    ind = find(DOCtable.cruise == 'EN695');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled','^');
    ind = find(DOCtable.cruise == 'EN712');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled','square');
    grid on; colorbar; axis([temprange saltrange]);
    flagged = find(DOCtable.quality_flag_n >1 & ismember(DOCtable.cruise,{'AT46','EN695','EN712'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title('Winter TN')
    caxis(tnrange)
%     clim(tnrange)
    legend('AT46','EN695','flag')
subplot 222 %spring
    ind = find(DOCtable.cruise == 'AR66B');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled');
    hold on
    ind = find(DOCtable.cruise == 'HRS2303');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled','^');
    grid on; colorbar; axis([temprange saltrange]);
    flagged = find(DOCtable.quality_flag_n >1 & ismember(DOCtable.cruise,{'AR66B','HRS2303'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title('Spring TN')
    caxis(tnrange)
%     clim(tnrange)
    legend('AR66B','HRS2303','flag')
subplot 223 %Summer
    ind = find(DOCtable.cruise == 'EN687');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled');
    hold on
    ind = find(DOCtable.cruise == 'EN706');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled','^');
    grid on; colorbar; axis([temprange saltrange]);
    flagged = find(DOCtable.quality_flag_n >1 & ismember(DOCtable.cruise,{'EN687','EN706'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title('Summer TN')
    caxis(tnrange)
%     clim(tnrange)
    legend('EN687','EN706','flag')
subplot 224 %Fall
    ind = find(DOCtable.cruise == 'AR77');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled','^');
    hold on
%     ind = find(DOCtable.cruise == 'EN695');
%     scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],DOCtable.tn(ind),'filled','*');
    grid on; colorbar; axis([temprange saltrange]);
    flagged = find(DOCtable.quality_flag_n >1 & ismember(DOCtable.cruise,{'AR77'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title('Fall TN')
    caxis(tnrange)
%     clim(tnrange)
    legend('AR77','flag')
%}

for loopcount = 1:3
    switch loopcount
        case 1
            toplot = DOCtable.npoc; thelim = docrange; fortitle = 'DOC';
        case 2
            toplot = DOCtable.tn; thelim = tnrange;  fortitle = 'TN'; 
        case 3
            toplot = DOCtable.npoc./DOCtable.tn; thelim = ratiorange; fortitle = 'DOC_DTN ratio';
    end
%Plot by season all cruises per season. Fig for each 
figure
subplot 221 %winter
    ind = find(DOCtable.cruise == 'AT46');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],toplot(ind),'filled');
    hold on
    ind = find(DOCtable.cruise == 'EN695');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],toplot(ind),'filled','^');
    ind = find(DOCtable.cruise == 'EN712');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],toplot(ind),'filled','pentagram');
    grid on; colorbar; axis([temprange saltrange]);
    flagged = find(DOCtable.quality_flag_c >1 & ismember(DOCtable.cruise,{'AT46','EN695','EN712'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title(['Winter ' fortitle])
    clim(thelim) %caxis(thelim)
    legend('AT46','EN695','EN712','flag','location','southeast')
subplot 222 %spring
    ind = find(DOCtable.cruise == 'AR66B');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],toplot(ind),'filled');
    hold on
    ind = find(DOCtable.cruise == 'HRS2303');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],toplot(ind),'filled','^');
    flagged = find(DOCtable.quality_flag_c >1 & ismember(DOCtable.cruise,{'AR66B','HRS2303'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    grid on; colorbar; axis([temprange saltrange]);
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title(['Spring ' fortitle])
    clim(thelim) %caxis(thelim)
    legend('AR66B','HRS2303','flag','location','southeast')
subplot 223 %Summer
    ind = find(DOCtable.cruise == 'EN687');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],toplot(ind),'filled');
    hold on
    ind = find(DOCtable.cruise == 'EN706');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],toplot(ind),'filled','^');
    flagged = find(DOCtable.quality_flag_c >1 & ismember(DOCtable.cruise,{'EN687','EN706'}));
    plot(DOCtable.temperature(flagged),DOCtable.salinity(flagged),'ro')
    grid on; colorbar; axis([temprange saltrange]);
    ylabel('Salinity','fontweight','bold'); xlabel('Temperature','fontweight','bold'); title(['Summer ' fortitle])
    clim(thelim) %caxis(thelim)
    legend('EN687','EN706','flag')
subplot 224 %Fall
    ind = find(DOCtable.cruise == 'AR77');
    scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],toplot(ind),'filled','^');
    hold on
%     ind = find(DOCtable.cruise == 'EN695');
%     scatter(DOCtable.temperature(ind),DOCtable.salinity(ind),[],toplot(ind),'filled','*');
    grid on; colorbar; axis([saltrange temprange]);
    flagged = find(DOCtable.quality_flag_c >1 & ismember(DOCtable.cruise,{'AR77'}));
    plot(DOCtable.salinity(flagged),DOCtable.temperature(flagged),'ro')
    xlabel('Salinity','fontweight','bold'); ylabel('Temperature','fontweight','bold'); title(['Fall ' fortitle])
    clim(thelim) %caxis(thelim)
   legend('AR77','flag')
   
   set(gcf,'position',[70 50 920 636])
   print([p 'plots' filesep 'NES-LTER_seasonal_' fortitle], '-dpng')
end



figure
for count = 1:4
subplot(2,2,count)
ind = find(DOCtable.season == season(count));
scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc(ind)./DOCtable.don(ind),'filled');
grid on; colorbar; axis([saltrange temprange]); clim([10 25]); %caxis([10 25]);
ylabel('Temperature','fontweight','bold'); xlabel('Salinity','fontweight','bold'); title(['DOC:DON ratio ' char(season(count))]);
end
figure
for count = 1:4
subplot(2,2,count)
ind = find(DOCtable.season == season(count));
scatter(DOCtable.latitude(ind),DOCtable.depth(ind),[],DOCtable.npoc(ind)./DOCtable.don(ind),'filled');
grid on; colorbar; clim([10 25]);
set(gca, 'XDir','reverse'); set(gca, 'YDir','reverse')
ylabel('Depth (m)','fontweight','bold'); xlabel('Latitude','fontweight','bold'); title(['DOC:DON ratio ' char(season(count))]);
end

%TS diagram with contours plotting DOC with season symbols
%SURFACE
figure
theta_sdiag(DOCtable.temperature,DOCtable.salinity);
hold on
symbol = 'o^sh';
for count = 1:4
    ind = find(DOCtable.season == season(count) & DOCtable.depth <7);
    scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc(ind),'filled','marker',symbol(count))
end
colorbar
clim(docrange)
h=get(gca,'children');
legend(flip(h(1:4)),'winter','spring','summer','fall','location','southeast')
title('SURFACE DOC TS plot')

%TS diagram with contours plotting DOC with season symbols
figure
theta_sdiag(DOCtable.temperature,DOCtable.salinity);
hold on
symbol = 'o^sh';
for count = 1:4
    ind = find(DOCtable.season == season(count));
    scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc(ind),'filled','marker',symbol(count))
end
colorbar
clim(docrange)
title('ALL DOC TS plot')

%1 FIG SEASONS TS diagram with contours plotting DOC with season symbols
figure
for count = 1:4
subplot(2,2,count)
theta_sdiag(DOCtable.temperature,DOCtable.salinity);
hold on
ind = find(DOCtable.season == season(count));
for count2 = 1:length(unique(DOCtable.cruise(ind)))
    scatter(DOCtable.salinity(ind),DOCtable.temperature(ind),[],DOCtable.npoc(ind),'filled','marker',symbol(count2))
end
ax=get(gca,'Children'); forleg = length(ax)-1;
legend(ax(flip(1:forleg)),unique(DOCtable.cruise(ind)))
colorbar; clim(docrange)
title(char(season(count)))
clear forleg in count2 ax 
end
