%Taylor 6/18/2019
%import NES-LTER chl mat file and plot things
%for now want to plot winter and summer size frac chl. 

load \\sosiknas1\Lab_data\LTER\code\NESLTERchl.mat
% load NESLTERchl.mat

% en608 = strmatch('EN608',chl(:,1));
% en617 = strmatch('EN617',chl(:,1));
stations = {'L1','L2','L3','L4','L5','L6','L7','L8', 'L9', 'L10', 'L11'};
cruises = {'EN608','EN617'};
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

%station_no = cell2mat(surf(:,4));
%station_no = str2num(station_no(:,2));
%station_no = char(surf(:,4));
%station_no = str2num(station_no(:,2:end));

T = cell2table(surf, "VariableNames", header);
station_no = str2num(char(regexprep(T.lter_station_x, 'L', '')));

w608 = find(strcmp('EN608',T.cruise) & T.filter_size == 0); 
lt608 = find(strcmp('EN608',T.cruise) & T.filter_size == 10);
[~,b608,c608] = intersect(T.lter_station_x(w608),T.lter_station_x(lt608)); 

w617 = find(strcmp('EN617',T.cruise) & T.filter_size == 0); 
lt617 = find(strcmp('EN617',T.cruise) & T.filter_size == 10);
[~,b617,c617] = intersect(T.lter_station_x(w617),T.lter_station_x(lt617)); 

subplot(221)
bar(station_no(w608), T.chl_avg(w608))
ylabel('Chl (mg m^{-3})','fontweight','bold'); xlabel('L station #','fontweight','bold'); title('Winter (EN608)');
subplot(222)
bar(station_no(w617), T.chl_avg(w617))
ylabel('Chl (mg m^{-3})','fontweight','bold'); xlabel('L station #','fontweight','bold'); title('Summer (EN617)');
ylim([0 6])

subplot(223)
X = T.chl_avg(lt608(c608))./T.chl_avg(w608(b608));
bar(station_no(w608(b608)), [X 1-X]*100, 'stacked')
title('Winter'); legend('<10um','>10um');
ylabel('Percentage of total Chl','fontweight','bold'); xlabel('L Station #','fontweight','bold');
ylim([0 100])
    
subplot(224)
X = T.chl_avg(lt617(c617))./T.chl_avg(w617(b617));
bar(station_no(w617(b617)), [X 1-X]*100, 'stacked')
title('Summer'); legend('<10um','>10um');
ylabel('Percentage of total Chl','fontweight','bold'); xlabel('L Station #','fontweight','bold');
ylim([0 100])
