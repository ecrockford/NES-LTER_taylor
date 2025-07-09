%taylor
%take raw imported NESLTERchl.xls 

%import select columns from file. Don't care about cal info etc.
datadir = '\\sosiknas1\Lab_data\LTER\CHL\';
file = 'NESLTERchl.xlsx';
sheetName = 'chl';
[cruise,lter_station,cast,niskin,replicate,filter_size,chl,phaeo,LabNB,quality_flag,Comments,Comments2] = fxn_importNESLTER_column_vectors([datadir file],sheetName);
data = [cruise num2cell(cast) num2cell(niskin) lter_station replicate num2cell(filter_size) num2cell(chl) num2cell(phaeo) LabNB num2cell(quality_flag) Comments Comments2];
%the header we want to output. this mimics python output of
%"Taylor_compare_chl_NESLTER" but doesn't include ratios and stuff at end.
header = {'cruise','cast','niskin','lter_station','filter_size','chl_x','chl_y','phaeo_x','phaeo_y','LabNB_x','LabNB_y','QCflag_x','QCflag_y'};

unq_cruise = unique(cruise);
disp(['First unique cruise cell is: "' char(unq_cruise(1)) '". We will skip this because it is empty']);
pause
disp('Press any key to continue');
for count = 2:length(unq_cruise)
    tempcruise = unq_cruise(count);
    tempdata = data(strmatch(tempcruise,cruise),:);
    unq_cast = unique(cell2mat(tempdata(:,2)));
    for count2 = 1:length(unq_cast)
        temptemp = tempdata(cell2mat(tempdata(:,2)) == unq_cast(count2),:);
        unq_niskin = unique(cell2mat(temptemp(:,3)));
        chloutput = [repmat(tempcruise,length(unq_niskin),1) repmat(num2cell(unq_cast(count2)),length(unq_niskin),1) num2cell(unq_niskin)]
        for count3 = 1:length(unq_niskin)
            chla = chlout(cell2mat(temptemp(:,3))==unq_niskin(count3) & strmatch('a',temptemp(:,5)),