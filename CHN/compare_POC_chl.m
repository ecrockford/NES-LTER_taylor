%Taylor 2/10/2023
% compare POC to chl

%load POC and PON. have propper lat/lon/depth from API
% p = 'C:\work\LTER\POC\';
p = '\\sosiknas1\Lab_data\LTER\CHN\';
load([p 'NESLTER_CHN_table'])
chn_var2use = {'cruise','cast','niskin','datetime','latitude','longitude','depth','CHN_sample_ID','replicate','POC_umolperL','PON_umolperL','POC_ugperL','PON_ugperL','CHNBlank','blank_estimated','blankC','blankN','C_quality_flag','N_quality_flag'};
CHNtable.sample_month = month(CHNtable.datetime);

chltable = readtable('\\sosiknas1\Lab_data\LTER\CHL\NESLTERchl.xlsx');
chltable = renamevars(chltable,["Cruise__","Cast_","Niskin_","Replicate","Chl_ug_l_","Phaeo_ug_l_","LabNotebookAndPageNumber","Comments","Comments2","quality_flag"],["cruise","cast","niskin","chl_rep","fl_chl","fl_phaeo","labNB","chl_comments","chl_comments2","chl_flag"]);

chltable.fl_chl(chltable.chl_flag == 3) = NaN;
chltable.fl_phaeo(chltable.chl_flag == 3) = NaN;

chl_var2use={'LTERStation','chl_rep','FilterSize','DilutionDuringReading','Chl_Cal_Filename','tau_Calibration','Fd_Calibration','Rb','Ra','fl_chl','fl_phaeo','Cal_Date','labNB','Date_analyzed','Fluorometer','chl_flag','QC_d','chl_comments','chl_comments2'};
chl_var4match = {'fl_chl','fl_phaeo','chl_flag'};
chltable = chltable(chltable.FilterSize==0,:); %only want to compare WSW - not size fractions

% THIS DOESN'T WORK BECAUSE NOT FROM SAME NISKIN
matchup = [];
unq_cruise = unique(CHNtable.cruise);
for cruise_count = 1:length(unq_cruise)
    cruise = CHNtable(categorical(CHNtable.cruise) == unq_cruise(cruise_count),:);
    unq_cast = unique(cruise.cast);
    for cast_count = 1:length(unq_cast)
        cast = cruise(cruise.cast == unq_cast(cast_count),:);
        unq_niskin = unique(cast.niskin);
        for niskin_count = 1:length(unq_niskin)
            n_ind = find(cast.niskin == unq_niskin(niskin_count));
%             chnfind = cast(n_ind(1),:);
            for sample_count = 1:length(n_ind)
                chl_ind = find(categorical(chltable.cruise) == unq_cruise(cruise_count) & chltable.cast == unq_cast(cast_count) & chltable.niskin == unq_niskin(niskin_count));
                if ~isempty(chl_ind)
                    avg_flag = nanmean(chltable.chl_flag(chl_ind));
                    avg_phaeo = nanmean(chltable.fl_phaeo(chl_ind));
                    avg_chl = nanmean(chltable.fl_chl(chl_ind));
                    chltemp = table(avg_chl,avg_phaeo,avg_flag);
                    temp = [cast(n_ind(sample_count),chn_var2use) chltemp];
                    matchup = [matchup; temp];
                end
                clear avg_* chltemp temp chl_ind
            end
%             clear n_ind npp_ind temp
        end
        clear niskin_count unq_niskin cast
    end
    clear unq_cast cruise
end
clear n_ind *count unq*
matchup.sample_month = month(matchup.datetime);

%plot C:chl ratio by sample count
%{
figure
plot(matchup.POC_ugperL./matchup.avg_chl,'.','MarkerSize',12))
hold on
% indB11 = find(categorical(matchup.CHNBlank) == 'B11');
% plot(indB11,matchup.POC_ugperL(indB11)./matchup.avg_chl(indB11),'gx')
% indB13 = find(categorical(matchup.CHNBlank) == 'B13');
% plot(indB13,matchup.POC_ugperL(indB13)./matchup.avg_chl(indB13),'rx')
xlabel('sample count','Fontweight','bold'); ylabel('ratio  POC(ugperL) : chl (ugperL)','Fontweight','bold');
title('ratio  POC(ugperL) : chl (ugperL)')
% legend('all',['B11=' num2str(matchup.blankC(indB11(1)))],['B13=' num2str(matchup.blankC(indB13(1)))],'location','best')
grid on
%}

%%%C:Chl RATIO OVER TIME - ALL SAMPLES
figure
plot(matchup.datetime,matchup.POC_ugperL./matchup.avg_chl,'.','MarkerSize',12)
hold on
% indB11 = find(categorical(matchup.CHNBlank) == 'B11');
% plot(matchup.datetime(indB11),matchup.POC_ugperL(indB11)./matchup.avg_chl(indB11),'gx')
% indB11 = find(categorical(matchup.CHNBlank) == 'B13');
% plot(matchup.datetime(indB11),matchup.POC_ugperL(indB11)./matchup.avg_chl(indB11),'rx')
% legend('all',['B11=' num2str(matchup.blankC(indB11(1)))],['B13=' num2str(matchup.blankC(indB13(1)))],'location','best')
xlabel('Date','Fontweight','bold'); ylabel('ratio  POC(ugperL) : chl (ugperL)','Fontweight','bold');
title('ALL ratio  POC(ugperL) : chl (ugperL)')
grid on


surface = matchup(matchup.depth < 6,:);
%%% C:Chl RATIO OVER TIME - SURFACE
figure
plot(surface.datetime,surface.POC_ugperL./surface.avg_chl,'.','MarkerSize',12)
hold on
% indB11 = find(categorical(surface.CHNBlank) == 'B11');
% plot(surface.datetime(indB11),surface.POC_ugperL(indB11)./surface.avg_chl(indB11),'gx')
% indB13 = find(categorical(surface.CHNBlank) == 'B13');
% plot(surface.datetime(indB13),surface.POC_ugperL(indB13)./surface.avg_chl(indB13),'rx')
% legend('all',['B11=' num2str(surface.blankC(indB11(1)))],['B13=' num2str(surface.blankC(indB13(1)))],'location','best')
xlabel('Date','Fontweight','bold'); ylabel('ratio POC(ugperL) : chl (ugperL)','Fontweight','bold');
title('SURFACE ratio  POC(ugperL) : chl (ugperL)')
grid on

figure
plot(surface.latitude,surface.POC_ugperL./surface.avg_chl,'.','MarkerSize',12))
hold on
indB11 = find(categorical(surface.CHNBlank) == 'B11');
plot(surface.latitude(indB11),surface.POC_ugperL(indB11)./surface.avg_chl(indB11),'gx')
indB13 = find(categorical(surface.CHNBlank) == 'B13');
plot(surface.latitude(indB13),surface.POC_ugperL(indB13)./surface.avg_chl(indB13),'rx')
legend('all',['B11=' num2str(surface.blankC(indB11(1)))],['B13=' num2str(surface.blankC(indB13(1)))],'location','best')
xlim([39.70 41.2])
xlabel('Latitude','Fontweight','bold'); ylabel('ratio POC(ugperL) : chl (ugperL)','Fontweight','bold');
title('SURFACE ratio  POC(ugperL) : chl (ugperL)')
grid on

%%% C:Chl RATIO BY DAY-OF-YEAR AND DEPTH
figure
scatter(day(matchup.datetime,'dayofyear'),matchup.depth,matchup.POC_ugperL./matchup.avg_chl,'.')


season_names = ["Winter";"Spring";"Summer";"Fall"];
season = table([1 2 12]', [3:5]', [6:8]', [9:11]','VariableNames',season_names);

figure
for count = 1:4
    subplot(4,1,count);
%     plot(matchup.latitude(ismember(matchup.sample_month,season.(count)) & matchup.N_quality_flag ==1 & matchup.avg_flag ==1),matchup.POC_ugperL(ismember(matchup.sample_month,season.(count)) & matchup.N_quality_flag ==1 & matchup.avg_flag ==1)./matchup.avg_chl(ismember(matchup.sample_month,season.(count)) & matchup.N_quality_flag==1 & matchup.avg_flag ==1),'.','markersize',10)
    toplot = find(ismember(matchup.sample_month,season.(count)) & matchup.N_quality_flag ==1 & matchup.avg_flag ==1);
    scatter(matchup.latitude(toplot),matchup.POC_ugperL(toplot)./matchup.avg_chl(toplot),[],year(matchup.datetime(toplot)),'filled')
%     scatter(matchup.latitude(ismember(matchup.sample_month,season.(count)) & matchup.N_quality_flag ==1 & matchup.avg_flag ==1),matchup.depth(ismember(matchup.sample_month,season.(count)) & matchup.N_quality_flag ==1 & matchup.avg_flag ==1),[],matchup.POC_ugperL(ismember(matchup.sample_month,season.(count)) & matchup.N_quality_flag ==1 & matchup.avg_flag ==1)./matchup.avg_chl(ismember(matchup.sample_month,season.(count)) & matchup.N_quality_flag==1 & matchup.avg_flag ==1),'filled')
    xlim([39.70 41.2]); ylim([0 700]); 
    grid on
%     xlim([39.70 41.2]); ylim([0 100]); 
    set(gca, 'XDir','reverse'); %set(gca, 'YDir','reverse'); 
    title(['NES-LTER transect POC:CHL - ' char(season_names(count))])
    ylabel('Carbon : Chl ratio','fontweight','bold'); 
%     ylabel('Depth (m)','fontweight','bold'); 
    c = colorbar; set(c,'ticks',[2017:2021]);
    caxis([2017 2021])
end
xlabel('Latitude','fontweight','bold');

figure
for count = 1:4
    subplot(4,1,count);
    toplot = find(ismember(matchup.sample_month,season.(count)) & matchup.N_quality_flag ==1 & matchup.avg_flag ==1 & matchup.depth <6);
    scatter(matchup.latitude(toplot),matchup.POC_ugperL(toplot)./matchup.avg_chl(toplot),[],year(matchup.datetime(toplot)),'filled')
    xlim([39.70 41.2]); ylim([0 700]); 
    set(gca, 'XDir','reverse'); grid on;
    title(['SURFACE - NES-LTER transect POC:CHL - ' char(season_names(count))])
    ylabel('Carbon : Chl ratio','fontweight','bold'); 
    c = colorbar; set(c,'ticks',[2017:2021]);
    caxis([2017 2021])
end
xlabel('Latitude','fontweight','bold');


figure
for count = 1:4
    subplot(4,1,count);
    plot(CHNtable.latitude(ismember(CHNtable.sample_month,season.(count)) & CHNtable.N_quality_flag == 1),CHNtable.C_to_N_molar_ratio(ismember(CHNtable.sample_month,season.(count)) & CHNtable.N_quality_flag == 1),'.','markersize',10)
    xlim([39.70 41.2]); ylim([0 15]); 
    grid on
    set(gca, 'XDir','reverse');
    title(['NES-LTER transect POC:PON - ' char(season_names(count))])
    ylabel('POC:PON molar ratio','fontweight','bold'); 
%     c = colorbar; set(c,'ticks',[2017:2021]);
%     caxis([2017 2021])
end
