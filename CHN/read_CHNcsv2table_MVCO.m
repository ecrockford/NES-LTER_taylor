% 2/11/2023 - AR24A C1 not getting imported because bottle file missing

%this mat-file generated by CHN_reps.m that loads MS Access table that
%combines depth/date/time/etc with the CHN Excel file
load \\sosiknas1\Lab_data\MVCO\mvcodata\matlab_files\CHN_data_reps.mat
clear *blanks*

%set header as categorical in chn_reps_v2 but need it as cell array to make variable names of table
header_chn=cellstr(header_chn);
CHNtable = cell2table(MVCO_CHN_reps,"VariableNames",header_chn); %original MVCO code makes cell array from MS Access. Conver to table
CHNtable = renamevars(CHNtable,["Event_Number","Event_Number_Niskin","Latitude","Longitude","Depth","Replicate","CHN_blank","CHN_amt_filt"], ["event_number","event_number_niskin","latitude","longitude","depth","replicate","CHNBlank","CHNVol"]); %rename variables to re-use existin LTER code
CHNtable.date_combustrun = str2num([num2str(CHNtable.Date_Combusted) num2str(CHNtable.Date_Analyzed)]); %combine date combust and analyzed to get unique identified for which blanks
CHNtable.matdate = matdate;
CHNtable.datetime = datestr(CHNtable.matdate,'yyyy-mm-dd HH:MM:SS');
CHNtable = removevars(CHNtable,{'Start_Date','Start_Time_UTC'});
clear header_chn MVCO* matdate

%%%%%%%%%%%%% QC step %%%%%%%%%%%%%
%first check each table row is a uniqeu sample. Each sample has a unique
%sample ID#. Are any accidentally re-used? i.e. are there double sample ID#s?
if length(unique(CHNtable.CHN_sample_ID)) ~= size(CHNtable,1)
    [num_occur, value] = groupcounts(CHNtable.CHN_sample_ID);
    disp('CHN sample ID#s that occur more than once: ')
    disp(CHNtable.CHN_sample_ID(num_occur > 1));
    error('CHN sample ID#s are not unique for full data table. Needs investigating. See list of duplicate ID#s above.')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%for calculations later from umol to ugL
C_atomic_wt = 12.0107; %g*mol^-1,  atomic weight of carbon
N_atomic_wt = 14.0067; %g*mol^-1,  atomic weight of nitrogen

%load CHN Blanks file for matchup to data
% p = '\\sosiknas1\Lab_data\LTER\CHN\';
load \\sosiknas1\Lab_data\LTER\CHN\CHNblanks2use.mat

%%%%%%%%%%%%%%%%%%%%%%%%%BLANK ADJUSTMENT%%%%%%%%%%%%%%%%%
%%%%%%%%% 2nd B4 analyzed 20151203 missing... does not exist
%%%%%%%%% average B4 run 20140713 and B5 run 20151203 for values
%%%%%%%%% this is done in the Excel CHN_BLANKS.xlsx spreadsheet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unq_combustrun = unique(CHNtable.date_combustrun);
for count = 1:length(unq_combustrun)
    unqblank = categorical(unique(CHNtable.CHNBlank(CHNtable.date_combustrun == unq_combustrun(count))));
    for count2 = 1:length(unqblank) %sometimes 2 diff blanks have the exact same combust and run dates, deal with this
        ind2 = find(CHNtable.date_combustrun == unq_combustrun(count) & CHNtable.CHNBlank == unqblank(count2) & ~isnan(CHNtable.umol_C));
        indblank = find(blanks2use.unq_date_combustrun == unq_combustrun(count) & blanks2use.CHN_blank == unqblank(count2));
        CHNtable.blankfromblankfile(ind2) = blanks2use.CHN_blank(indblank);
        CHNtable.blankN(ind2) = blanks2use.nitrogen(indblank);
        CHNtable.blankC(ind2) = blanks2use.carbon(indblank);
        CHNtable.blank_estimated(ind2) = blanks2use.blank_estimated(indblank);
%         CHNtable.blankfromblankfile(ind2) = blanks2use.CHN_blank(blanks2use.unq_date_combustrun == unq_combustrun(count));
%         CHNtable.blankN(ind2) = blanks2use.nitrogen(blanks2use.unq_date_combustrun == unq_combustrun(count));
%         CHNtable.blankC(ind2) = blanks2use.carbon(blanks2use.unq_date_combustrun == unq_combustrun(count));
    end
end
clear count* ind* unq*

%retain non-blank adjusted values to reference
CHNtable.raw_umol_C = CHNtable.umol_C;
CHNtable.raw_umol_N = CHNtable.umol_N;

%subtract blank before arithmetic
CHNtable.umol_C_blank_adj = CHNtable.umol_C - CHNtable.blankC;
CHNtable.umol_N_blank_adj = CHNtable.umol_N - CHNtable.blankN;


% CHNtable.datetime = datetime(CHNtable.date, 'InputFormat', 'yyyy-MM-dd HH:mm:ss+00:00');
CHNtable.POC_umolperL = CHNtable.umol_C_blank_adj./CHNtable.CHNVol*1000; %micromolar = micromol per liter
CHNtable.PON_umolperL = CHNtable.umol_N_blank_adj./CHNtable.CHNVol*1000; %micromolar = micromol per liter
CHNtable.POC_ugperL = CHNtable.umol_C_blank_adj*C_atomic_wt./CHNtable.CHNVol*1000; %microgram per liter
CHNtable.PON_ugperL = CHNtable.umol_N_blank_adj*N_atomic_wt./CHNtable.CHNVol*1000; %microgram per liter
CHNtable.C_to_N_molar_ratio = CHNtable.POC_umolperL./CHNtable.PON_umolperL; %mol_per_mol

%change Inf ratios to nan for easier data handling and EDI missing value of nan
ind = find(~isfinite(CHNtable.C_to_N_molar_ratio));
CHNtable.C_to_N_molar_ratio(ind) = NaN;

%output set significant digits for each variable but also avoid using fprintf
%first round to S.D. desired and then Matlab formate of longG is how it's displayed but is also how it is written to csv
CHNtable.latitude = round(CHNtable.latitude,4);
CHNtable.longitude = round(CHNtable.longitude,4);
CHNtable.depth = round(CHNtable.depth,2);
CHNtable.POC_umolperL = round(CHNtable.POC_umolperL,3);
CHNtable.PON_umolperL = round(CHNtable.PON_umolperL,3);
CHNtable.POC_ugperL = round(CHNtable.POC_ugperL,3);
CHNtable.PON_ugperL = round(CHNtable.PON_ugperL,3);
CHNtable.C_to_N_molar_ratio = round(CHNtable.C_to_N_molar_ratio,3);
format longG


% CHNtable = renamevars(CHNtable,["Cruise", "Cast", "Niskin_"], ["cruise", "cast", "niskin"]);
CHNtable = removevars(CHNtable,{'umol_N','umol_C'});

%LTER transect with cruise/cast/niskin% var2use = {'cruise','cast','niskin','date','datetime','latitude','longitude','depth','CHN_sample_ID','replicate','raw_umol_C','raw_umol_N','umol_C_blank_adj','umol_N_blank_adj','POC_umolperL','PON_umolperL','POC_ugperL','PON_ugperL','C_to_N_molar_ratio','Date_Combusted','DateAnalyzed','CHNBlank','blank_estimated','blankC','blankN','C_quality_flag','N_quality_flag'};
var2use = {'event_number','event_number_niskin','matdate','datetime','latitude','longitude','depth','CHN_sample_ID','replicate','raw_umol_C','raw_umol_N','umol_C_blank_adj','umol_N_blank_adj','POC_umolperL','PON_umolperL','POC_ugperL','PON_ugperL','C_to_N_molar_ratio','Date_Combusted','Date_Analyzed','CHNBlank','blank_estimated','blankC','blankN','C_quality_flag','N_quality_flag'};
CHNtable = CHNtable(:,var2use);

README_flags = {'POC and PON quality flags';'1 = good';'2 = suspect/questionable';'3 = bad, set to nan';'6 = Below Detection Limit';'9 = missing data, NA'};

p = '\\sosiknas1\Lab_data\MVCO\mvcodata\matlab_files\';

%write data as MATLAB table
save([p 'MVCO_CHN_calculated_table'],'CHNtable','README_flags');

%write same data as csv
writetable(CHNtable, [p 'MVCO_CHN_calculated.csv'], 'WriteVariableNames', true);


%write csv for EDI with only variables to publish
% var2use4EDI = {'cruise','cast','niskin','date','latitude','longitude','depth','replicate','POC_umolperL','PON_umolperL','POC_ugperL','PON_ugperL','C_to_N_molar_ratio','quality_flag'};
var2use4EDI = {'event_number','event_number_niskin','datetime','latitude','longitude','depth','replicate','POC_umolperL','PON_umolperL','POC_ugperL','PON_ugperL','C_to_N_molar_ratio','C_quality_flag','N_quality_flag'};
CHNtable4EDI = CHNtable(:,var2use4EDI);
CHNtable4EDI = renamevars(CHNtable4EDI,["datetime","POC_umolperL","PON_umolperL","POC_ugperL","PON_ugperL"],["date_time_utc","POC_micromolar","PON_micromolar","POC_microg_perL","PON_microg_perL"]);

%for data table set Inf to NA
% below is how would set cells to a string of 'NA' in a numerica column. but leave as nan because leaving C and N data values as nan
% CHNtable4EDI.C_to_N_molar_ratio = categorical(CHNtable4EDI.C_to_N_molar_ratio);
% CHNtable4EDI.C_to_N_molar_ratio(ind) = 'NA';

writetable(CHNtable4EDI, '\\sosiknas1\Lab_data\MVCO\mvcodata\EDI\CHN\nes-lter-poc-mvco.csv', 'WriteVariableNames', true);

clear var2use