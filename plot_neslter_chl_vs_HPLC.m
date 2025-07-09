

load('\\sosiknas1\Lab_data\LTER\HPLC\data\NESLTER_HPLC_data.mat')
% load \\sosiknas1\Lab_data\LTER\code\NESLTERchl.mat
chl = import_NESLTERchl('\\sosiknas1\Lab_data\LTER\CHL\NESLTERchl.xlsx');
HPLC_metavar = ["cruise","cast","niskin","matdate","HSL_id", "duplicate", "depth", "TotalWaterDepthmeters", "Latitude", "Longitude","comments"];
HPLC_pigvar = ["Tot_Chl_a","TChl","TChlaTPg"];

fix = chl.Properties.VariableNames';
chl.Properties.VariableNames(strcmp(fix,'Replicate')) = {'chl_rep'};
chl.Properties.VariableNames(strcmp(fix,'Chlugl')) = {'fl_chl'};
chl.Properties.VariableNames(strcmp(fix,'Phaeougl')) = {'fl_phaeo'};
chl.Properties.VariableNames(strcmp(fix,'LabnotebookandPagenumber')) = {'labNB'};
chl.Properties.VariableNames(strcmp(fix,'Comments')) = {'chl_comments'};
chl.Properties.VariableNames(strcmp(fix,'Comments2')) = {'chl_comments2'};
chl.Properties.VariableNames(strcmp(fix,'quality_flag')) = {'chl_flag'};
clear fix

chl_var2use={'LTERStation','chl_rep','FilterSize','DilutionDuringReading','Chl_Cal_Filename','tau_Calibration','Fd_Calibration','Rb','Ra','fl_chl','fl_phaeo','Cal_Date','labNB','Date_analyzed','Fluorometer','chl_flag','QC_d','chl_comments','chl_comments2'};

HPLC = HPLC(:,[HPLC_metavar HPLC_pigvar]); %get rid of accecory pigments not of interest
chl = chl(chl.FilterSize==0,:); %only want to compare WSW - not size fractions

matchup = [];
unq_cruise = unique(HPLC.cruise);
for cruise_count = 1:length(unq_cruise)
    cruise = HPLC(HPLC.cruise == unq_cruise(cruise_count),:);
    unq_cast = unique(cruise.cast);
    for cast_count = 1:length(unq_cast)
        cast = cruise(cruise.cast == unq_cast(cast_count),:);
        unq_niskin = unique(cast.niskin);
        for niskin_count = 1:length(unq_niskin)
            n_ind = find(cast.niskin == unq_niskin(niskin_count));
            Hpig = cast(n_ind(1),HPLC_pigvar);
%             if length(Hpig) >1
%                 for pig_count = 1:length(HPLC_pigvar)
%                     Hpig(pig_count) = nanmean(Hpig(:,pig_count));
%                 end
%             end
            chl_ind = find(chl.Cruise == unq_cruise(cruise_count) & chl.Cast == unq_cast(cast_count) & chl.Niskin == unq_niskin(niskin_count));
            temp = [repmat(cast(n_ind(1),HPLC_metavar),length(chl_ind),1) repmat(Hpig,length(chl_ind),1) chl(chl_ind,chl_var2use)];
            matchup = [matchup; temp];
            clear n_ind Hpig chl_ind temp
        end
        clear niskin_count unq_niskin cast
    end
    clear unq_cast cruise
end
        
clear *count chl* datafiles HPLC* unq*

%NESLTERchl does not have the date analyzed entered
%made a lookup table of labNB page and date analyzed 
%use this loop to matchup for date analyzed and fill in matchup table
lookup = import_labNBlookup('\\sosiknas1\Lab_data\LTER\CHL\chl_labNBlookup.xlsx');
unq_labNB = unique(matchup.labNB);
for count = 1:length(unq_labNB)
    if ~strncmp('en608',char(unq_labNB(count)),5)
    matchup.Date_analyzed(matchup.labNB == unq_labNB(count)) = lookup.date(lookup.labNB == unq_labNB(count));
    end
end
clear count unq_labNB

save NESLTER_flchl_HPLC_matchup

avgratio=mean([matchup.fl_chl./matchup.Tot_Chl_a]);
plot(matchup.labNB,[matchup.fl_chl./matchup.Tot_Chl_a]-avgratio,'.')
plot(matchup.Date_analyzed,[matchup.fl_chl./matchup.Tot_Chl_a]-avgratio,'.')
plot(matchup.labNB,[matchup.fl_chl./matchup.Tot_Chl_a],'.')
plot(matchup.Date_analyzed,[matchup.fl_chl./matchup.Tot_Chl_a],'.')

dividerdates = [20181101; 20191222];
matchup.yearday = datenum2yearday(datenum(num2str(matchup.Date_analyzed),'yyyymmdd'));
ind_cal2018 = find(matchup.Date_analyzed < 20181101);
ind_cal2019 = find(matchup.Date_analyzed > 20181101 & matchup.Date_analyzed < 20191222);
ind_cal2020 = find(matchup.Date_analyzed > 20191222);

figure
subplot(311)
plot(matchup.yearday(ind_cal2018), matchup.fl_chl(ind_cal2018)./matchup.Tot_Chl_a(ind_cal2018),'.r','markersize',10)
hold on
line([0 366], [1 1],'color','k','linestyle','--')
ylabel('Ratio FlChl:TChla','fontweight','bold');
xlabel('yearday','fontweight','bold');
title('2018 analyzed chl w 2018cal - ratio flchl:Tchla')
xlim([0 366])
subplot(312)
plot(matchup.yearday(ind_cal2019), matchup.fl_chl(ind_cal2019)./matchup.Tot_Chl_a(ind_cal2019),'.r','markersize',10)
hold on
line([0 366], [1 1],'color','k','linestyle','--')
ylabel('Ratio FlChl:TChla','fontweight','bold');
xlabel('yearday','fontweight','bold');
title('2019 analyzed chl w 2018cal - ratio flchl:Tchla')
xlim([0 366])
subplot(313)
plot(matchup.yearday(ind_cal2020), matchup.fl_chl(ind_cal2020)./matchup.Tot_Chl_a(ind_cal2020),'.r','markersize',10)
hold on
line([0 366], [1 1],'color','k','linestyle','--')
ylabel('Ratio FlChl:TChla','fontweight','bold');
xlabel('yearday','fontweight','bold');
title('2020 analyzed chl w NEW 2020cal - ratio flchl:Tchla')
xlim([0 366])

figure
plot(matchup.Latitude(ind_cal2018),matchup.fl_chl(ind_cal2018)./matchup.Tot_Chl_a(ind_cal2018),'.r','markersize',12)
hold on
plot(matchup.Latitude(ind_cal2019),matchup.fl_chl(ind_cal2019)./matchup.Tot_Chl_a(ind_cal2019),'xr','markersize',5)
line([39.6 41.4], [1 1],'color','k','linestyle','--')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%FIG 1 - COMPARE CHL REPS A VS B- WHOLE CHL ONLY%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a pain because matchup is not a and b on same row. skip for now
% figure('name','FL CHL Rep A vs B')
% plot(matchup.
% hold on
% line([0 8], [0 8])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%FIG 2 - COMPARE HPLC REPS A VS B - TCHLA %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a pain because matchup is not a and b on same row. skip for now
% figure('name','HPLC TCHLA Rep A vs B')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%FIG 3 - RATIO FL CHL:MEAN HPLC TCHLA %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('name','Ratio FL CHL:HPLC TCHLA over time')
% Color code points by Cal date of Chl Fl
colormat = [1 0 0;.6 0 0; 1 0 1; 1 .8 1; 1 .6 0; .6 .4 0;1 1 0; 0 1 0;.4 .4 0; .2 .6 0; 0 .6 .4; 0 1 1; 0 0 1; 0 0 .4; .8 .6 1; .6 0 1; .2 0 .4; .4 0 0; 0 0 0; .6 .6 .6];
%colormat key [1 red; 2 brick; 3 pink; 4 light pink; 5 orange; 6gold; 7 yellow; 8 green; 9 olive; 10 dark green; 11 blue/green; 12 light blue; 13 blue; 14 navy; 15 light purple; 16 purple; 17 egglplant 18 brown; 19 black; 20 gray; ]

% unq_caldate = unique(matchup.