%Taylor Nov 2019
%QC SPIROPA chl - heavily mimicked code read_MVCO_chl_rep.m 
%use Python created csv file of SPIROPA chl which pulls from main Excel
%sheet and do some plotting
clear all, close all

filename = 'C:\data\NESLTER_chl_merged.csv';
filename = '\\sosiknas1\Lab_data\LTER\CHL\NESLTER_chl_merged.csv';
[chl, header] = importPythonNESLTERcsv(filename);

percent_range = range([chl.chl_x chl.chl_y],2)./nanmean([chl.chl_x chl.chl_y],2)*100;
percent_range_phaeo = range([chl.phaeo_x chl.phaeo_y],2)./nanmean([chl.phaeo_x chl.phaeo_y],2)*100;  
ratios = [chl.phaeo_x chl.phaeo_y]./[chl.chl_x chl.chl_y];
ratios_percent_range = range(ratios,2)./nanmean(ratios(:))*100;  %case for whole water
badind = find(max([chl.QCflag_x chl.QCflag_y]')' == 3);
flag2ind = find(max([chl.QCflag_x chl.QCflag_y]')' == 2);
goodind = find(min([chl.QCflag_x chl.QCflag_y]')' == 1);

wsw = find(chl.filter_size == 0);
lt10 = find(chl.filter_size == 10);
gt5gt20 = find(chl.filter_size == 5 | chl.filter_size == 20);

%salculate Zscore of chl replicates and list them in order of highest to
%lowest Zscore (i.e. the worst ones) but only list the "todisplay" length
%which is defaulted to 50 right now. 
6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%FIG 1 - HISTO REP RAGNE/MEAN%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('name','NESLTER Histo Chl Replicate range/mean (%)')
hist(percent_range(goodind), [0:5:max(percent_range(goodind))]), ylabel('# of events'), xlabel('Replicate range / mean (%)')
xlim([-2.5 inf])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%FIG 2 - CHL REP RAGNE/MEAN OVER TIME%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = find(percent_range > 20);

figure('name','NESLTER Chl replicate range / mean (%) over time')
plot(percent_range ,'.','color',[0 0.4 0])
hold on
plot(lt10,percent_range(lt10),'.','color',[0.5 0.2 1]) %plot <10um in purple
plot(gt5gt20,percent_range(gt5gt20),'m.') %plot >5um & >20um in magenta
plot(badind, percent_range(badind) ,'r*')  %already flagged bad (flag 3 = throw out)
plot(flag2ind, percent_range(flag2ind) ,'go')  %already flagged flag 2 = questionable
line([0 size(percent_range,1)], [20 20],'color','r','linestyle','--');
ylabel('Chl replicate range / mean (%)'); xlabel('Event index number');
%find cases with whole chl range > 20% of mean
legend('WSW','<10','>5 & >20','flag =3','flag = 2','ratio 20%','location','best')

disp('events with high range for replicates (>20%)')
disp([header(1:3) header(5) 'percent range' header(6:7) header(12:13) header(16:17)])
disp([cellstr(chl.cruise(ind)) num2cell(chl.cast(ind)) num2cell(chl.niskin(ind)) num2cell(chl.filter_size(ind)) num2cell(floor(percent_range(ind))) num2cell(chl.chl_x(ind)) num2cell(chl.chl_y(ind)) num2cell(chl.QCflag_x(ind)) num2cell(chl.QCflag_y(ind)) num2cell(chl.qc_d_x(ind)) num2cell(chl.qc_d_y(ind)) num2cell(chl.LabNB_x(ind)) num2cell(chl.LabNB_y(ind)) cellstr(chl.comments_x(ind)) cellstr(chl.comments_y(ind))])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%FIG 3 - PHAEO REP RAGNE/MEAN OVER TIME%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = find(percent_range_phaeo > 30);

figure('name','NESLTER Phaeo replicate range / mean (%) over time')
plot(percent_range_phaeo ,'.','markersize',9,'color',[0.4 0.2 0])
ylabel('Phaeo replicate range / mean (%)')
xlabel('Event index number')
hold on
plot(lt10,percent_range_phaeo(lt10),'.','color',[0.5 0.2 1]) %plot <10um in purple
plot(gt5gt20,percent_range_phaeo(gt5gt20),'m.') %plot >5um & >20um in magenta
plot(badind, percent_range_phaeo(badind) ,'r*')  %already flagged bad (flag 3 = throw out)
plot(flag2ind, percent_range_phaeo(flag2ind) ,'go')
line([0 size(percent_range_phaeo,1)], [30 30],'color','r','linestyle','--');
legend('WSW','<10','>5 & >20','flag =3','flag = 2','ratio 30%','location','best')

disp('events with high phaeo range for replicates (>30%)')
disp([header(1:3) header(5) 'percent range' header(6:9) header(12:13) header(16:17) header(10:11)])
disp([cellstr(chl.cruise(ind)) num2cell(chl.cast(ind)) num2cell(chl.niskin(ind)) num2cell(chl.filter_size(ind)) num2cell(floor(percent_range_phaeo(ind))) num2cell(chl.chl_x(ind)) num2cell(chl.chl_y(ind)) num2cell(chl.phaeo_x(ind)) num2cell(chl.phaeo_y(ind)) num2cell(chl.QCflag_x(ind)) num2cell(chl.QCflag_y(ind)) num2cell(chl.qc_d_x(ind)) num2cell(chl.qc_d_y(ind)) num2cell(chl.LabNB_x(ind)) num2cell(chl.LabNB_y(ind))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%FIG 4 - RATIO PHAEO:CHL REP RAGNE/MEAN OVER TIME%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = find(ratios_percent_range > 50);

figure('name','Percent Range: Phaeo/Chl replicate range / mean (%) over time')
plot(ratios_percent_range ,'b.')
title('Phaeo:Chl percent range')
ylabel('Phaeo/Chl replicate range / mean (%)')
xlabel('Event index number')
%find cases with range > 20% of mean
hold on
plot(badind, ratios_percent_range(badind),'r*')%flag 3 = thrown out
plot(flag2ind, ratios_percent_range(flag2ind),'go')%flag 3 = thrown out
line([0 size(ratios_percent_range,1)], [50 50],'color','r','linestyle','--')

disp('events with high range for phaeo/chl replicates (> 50%)')
disp([header(1:3) header(5) 'phaeo/chl % range' header(6:9) header(12:13) header(16:17) header(10:11)])
disp([cellstr(chl.cruise(ind)) num2cell(chl.cast(ind)) num2cell(chl.niskin(ind)) num2cell(chl.filter_size(ind)) num2cell(floor(ratios_percent_range(ind))) num2cell(chl.chl_x(ind)) num2cell(chl.chl_y(ind)) num2cell(chl.phaeo_x(ind)) num2cell(chl.phaeo_y(ind)) num2cell(chl.QCflag_x(ind)) num2cell(chl.QCflag_y(ind)) num2cell(chl.qc_d_x(ind)) num2cell(chl.qc_d_y(ind)) num2cell(chl.LabNB_x(ind)) num2cell(chl.LabNB_y(ind))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%FIG 5 - RATIO PHAEO:CHL OVER DEPTH %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%phaeo at deeper depths (~>40?) higher than chl%%%%%%%%%%%%%%%%%%%%%
%NESLTERCHL DOES NOT HAVE TARGET DEPTH INPUTTED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure('name','Ratio Phaeo/Chl vs Depth')
% plot(chl.target_depth,ratios(:,1),'b.','markersize',9)
% hold on
% plot(chl.target_depth(badind),ratios(badind,1),'r*')
% plot(chl.target_depth(flag2ind),ratios(flag2ind,1),'go')
% ylabel('Phaeo/Chl replicate range / mean (%)','fontweight','bold'); xlabel('Depth (m)','fontweight','bold');
% title('Phaeo:Chl Percent Range vs Depth');
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%FIG 6 - COMPARE CHL REPS A VS B- WHOLE CHL ONLY%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find max and min values for limits to make plot square
chlmax = ceil(max([chl.chl_x; chl.chl_y])); chlmin = floor(min([chl.chl_x; chl.chl_y]));

figure
hold on
line([0 chlmax], [0 chlmax],'color','k','linestyle','--')
plot(chl.chl_x, chl.chl_y, '.', 'markersize', 15)
plot(chl.chl_x(badind), chl.chl_y(badind), 'r*')
plot(chl.chl_x(flag2ind), chl.chl_y(flag2ind), 'go')
legend('1:1 line','quality 1/2', 'quality 3','location','best')
ylabel('Chl - rep b'); xlabel('Chl - rep a'); title('NESLTER chl rep a vs rep b');
axis([chlmin chlmax chlmin chlmax]); axis square; grid on





