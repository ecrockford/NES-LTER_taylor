%Taylor 6/18/2019
%import NES-LTER chl mat file and plot things
%for now want to plot winter and summer size frac chl. 

load \\sosiknas1\Lab_data\LTER\code\NESLTERchl.mat
% en608 = strmatch('EN608',chl(:,1));
% en617 = strmatch('EN617',chl(:,1));
% stations = {'L1','L2','L3','L4','L5','L6','L7','L8'};
stations = {'L1','L2','L3','L4','L5','L6','L7','L8','L9','L10','L11','u11c','MVCO'}; %stations for all of EN627
% cruises = {'EN608','EN617'};
cruises = {'EN617'};
surf = [];
for cruise_count = 1:length(cruises)
ind = ismember(chl(:,4),stations) & strcmp(cruises(cruise_count),chl(:,1));
data = chl(ind,:);
cast = cell2mat(data(:,2)); niskin = cell2mat(data(:,3));
unq_cast = unique(cell2mat(data(:,2)));
for count = 1:length(unq_cast)
    ind = find(cast == unq_cast(count) & niskin == max(niskin(cast == unq_cast(count))));
    surf = [surf; data(ind,:)];
end
end


station_no = cell2mat(surf(:,4));
station_no = str2num(station_no(:,2));


%plot absolute z-score vs but not visually very helpful
%{
figure
subplot(221)
plot(cell2mat(AMwsw(:,17)),cell2mat(AMwsw(:,16)),'b.','markersize',13)
hold on; grid on
plot(cell2mat(PMwsw(:,17)),cell2mat(PMwsw(:,16)),'r.','markersize',13)
title([char(cruises) '  WSW Chl - Absolute Z-score']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Absolute Z-score','fontweight','bold');
subplot(222)
plot(cell2mat(AMlt10(:,17)),cell2mat(AMlt10(:,16)),'b.','markersize',13)
hold on; grid on
plot(cell2mat(PMlt10(:,17)),cell2mat(PMlt10(:,16)),'r.','markersize',13)
title([char(cruises) '  <10um Chl - Absolute Z-score']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Absolute Z-score','fontweight','bold');
subplot(223)
plot(cell2mat(AMgt5(:,17)),cell2mat(AMgt5(:,16)),'b.','markersize',13)
hold on; grid on
plot(cell2mat(PMgt5(:,17)),cell2mat(PMgt5(:,16)),'r.','markersize',13)
title([char(cruises) '  >5um Chl - Absolute Z-score']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Absolute Z-score','fontweight','bold');
subplot(224)
plot(cell2mat(AMgt20(:,17)),cell2mat(AMgt20(:,16)),'b.','markersize',13)
hold on; grid on
plot(cell2mat(PMgt20(:,17)),cell2mat(PMgt20(:,16)),'r.','markersize',13)
title([char(cruises) '  >20um Chl - Absolute Z-score']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Absolute Z-score','fontweight','bold');
%}

%{
figure
subplot(221)
bar(station_no(strcmp('EN608',surf(:,1)) & cell2mat(surf(:,5))==0),nanmean(cell2mat(surf(strcmp('EN608',surf(:,1)) & cell2mat(surf(:,5))==0,6:7)),2))
ylabel('Avg Chl','fontweight','bold'); xlabel('L Station #','fontweight','bold'); title('Avg Chl EN608');
subplot(222)
bar(station_no(strcmp('EN617',surf(:,1)) & cell2mat(surf(:,5))==0),nanmean(cell2mat(surf(strcmp('EN617',surf(:,1)) & cell2mat(surf(:,5))==0,6:7)),2))
ylabel('Avg Chl','fontweight','bold'); xlabel('L Station #','fontweight','bold'); title('Avg Chl EN617');

% lt10=surf(cell2mat(surf(:,5))==10 & strcmp('EN608',surf(:,1)),:);
% wsw = surf(ismember(surf(:,4),surf(lt10,4)) & cell2mat(surf(:,5))==0 & strcmp('EN608',surf(:,1)),:);
% lt10fraction = (nanmean(cell2mat(lt10(:,6:7)),2)./nanmean(cell2mat(wsw(:,6:7)),2))*100;
lt10ind = find(cell2mat(surf(:,5))==10 & strcmp('EN608',surf(:,1)));
wswind = find(cell2mat(surf(:,5))==0 & strcmp('EN608',surf(:,1)) & ismember(cell2mat(surf(:,3)),cell2mat(surf(lt10ind,3))));
lt10fraction = zeros(8,1);
temp=char(surf(lt10ind,4));
st4plot=str2num(temp(:,2));
lt10fraction(st4plot) = (nanmean(cell2mat(surf(lt10ind,6:7)),2)./nanmean(cell2mat(surf(wswind,6:7)),2))*100;
wswfraction = 100 - lt10fraction;
wswfraction(wswfraction==100)=0

subplot(223)
bar([lt10fraction wswfraction],'stacked')
title('Winter Size Fraction of total chl'); legend('<10um','>10um');
ylabel('Fraction of Total Chl','fontweight','bold'); xlabel('L Station #','fontweight','bold');

% lt10=surf(cell2mat(surf(:,5))==10 & strcmp('EN617',surf(:,1)),:);
% wsw = surf(ismember(surf(:,4),surf(lt10,4)) & cell2mat(surf(:,5))==0 & strcmp('EN617',surf(:,1)),:);
% lt10fraction = (nanmean(cell2mat(lt10(:,6:7)),2)./nanmean(cell2mat(wsw(:,6:7)),2))*100;
lt10ind = find(cell2mat(surf(:,5))==10 & strcmp('EN617',surf(:,1)));
wswind = find(cell2mat(surf(:,5))==0 & strcmp('EN617',surf(:,1)) & ismember(cell2mat(surf(:,3)),cell2mat(surf(lt10ind,3))));
lt10fraction = (nanmean(cell2mat(surf(lt10ind,6:7)),2)./nanmean(cell2mat(surf(wswind,6:7)),2))*100;
wswfraction = 100 - lt10fraction;

subplot(224)
bar([lt10fraction wswfraction],'stacked')
title('Summer Size Fraction of total chl'); legend('<10um','>10um');
ylabel('Fraction of Total Chl','fontweight','bold'); xlabel('L Station #','fontweight','bold');
%}
