%Taylor Dec 2019
%import LTER HPLC data produced by NASA Goddard. This assumes a standard
%format of data files received from Goddard. 

datadir = '\\sosiknas1\Lab_data\LTER\HPLC\data\';
datafiles = dir([datadir 'Sosik*report.xls*']);
datafiles = {datafiles.name}';
datalines2read_in_excelfile = [10, 141; 10, 360; 10, 140];

var2use = ["GSFCLabsamplecode", "SampleLabel", "CruiseID", "Indicateiffiltersarereplicates", "Volumefilteredml", "Station", "BottleNumber", "SamplingDepthmeters", "TotalWaterDepthmeters", "Year", "Month", "DayofGregorianMonth", "GMTTime", "Longitude", "Latitude", "Tot_Chl_a", "Tot_Chl_b", "Tot_Chl_c", "Alpha_beta_Car", "Butfuco", "Hexfuco", "Allo", "Diadino", "Diato", "Fuco", "Perid", "Zea", "MV_Chl_a", "DV_Chl_a", "Chlide_a", "MV_Chl_b", "DV_Chl_b", "Chlc1c2", "Chl_c3", "Lut", "Neo", "Viola", "Phytin_a", "Phide_a", "Pras", "Gyro", "TChl", "PPC", "PSC", "PSP", "TCar", "TAcc", "TPg", "DP", "TAccTchla", "PSCTCar", "PPCTCar", "TChlTCar", "PPCTpg", "PSPTPg", "TChlaTPg", "comments", "other", "other1"];
HPLC = [];
for count = 1:length(datafiles)
    filename = [datadir char(datafiles(count))];
    temp = importHPLC_fromGoddard(filename,"Report",datalines2read_in_excelfile(count,:));
    temp = temp(~ismissing(temp.SampleLabel,""),:);
    if strcmp(char(datafiles(count)),'Sosik08-15report.xlsx')
        temp.GMTTime(temp.CruiseID == 'EN617' & temp.Station == 21) = '12:58';
        temp.GMTTime(temp.CruiseID == 'EN617' & temp.Station == 35) = '01:13';
    end
    if strcmp(char(datafiles(count)),'Sosik_12-08_report.xlsx')
        temp.GMTTime(temp.CruiseID == 'TN368' & temp.Station == 125) = '12:38';
    end
    temp.matdate = datenum([num2str(temp.Year) char(temp.Month) num2str(temp.DayofGregorianMonth) repmat(' ', size(temp,1),1) char(temp.GMTTime)],'yyyymmmdd HH:MM');
    HPLC = [HPLC; temp];
end

fix = HPLC.Properties.VariableNames';
HPLC.Properties.VariableNames(strcmp(fix,'CruiseID')) = {'cruise'};
HPLC.Properties.VariableNames(strcmp(fix,'Station')) = {'cast'};
HPLC.Properties.VariableNames(strcmp(fix,'BottleNumber')) = {'niskin'};
HPLC.Properties.VariableNames(strcmp(fix,'SamplingDepthmeters')) = {'depth'};
HPLC.Properties.VariableNames(strcmp(fix,'SampleLabel')) = {'HSL_id'};
HPLC.Properties.VariableNames(strcmp(fix,'GSFCLabsamplecode')) = {'GSFC_id'};
HPLC.Properties.VariableNames(strcmp(fix,'Indicateiffiltersarereplicates')) = {'duplicate'};
HPLC.Properties.VariableNames(strcmp(fix,'other')) = {'comment2'};
HPLC.Properties.VariableNames(strcmp(fix,'other1')) = {'comment3'};

save \\sosiknas1\Lab_data\LTER\HPLC\data\NESLTER_HPLC_data HPLC datafiles