%Taylor - took some code form Heidi's transect_by_cruise.m for nutrients
%Loops through all cruises API nut data and save to sosiknas.
%other QC code working off of downloaded files and sometimes updates are
%needed to be update. 

%Bofu's qc flagging code loops through cruises so instead of saving 1 large
%file save each as the cruise csv.

%cruises = readtable("C:\Users\heidi\Downloads\cruise_metadata.csv");
opt = weboptions('Timeout', 60);
cruises = webread('https://nes-lter-data.whoi.edu/api/cruises/metadata.csv', opt);
cruises = cruises.cruise;


for count1 = 1:length(cruises)
    disp(cruises{count1})
    opt = weboptions('Timeout', 120);
    try
        %opt = detectImportOptions(['https://nes-lter-data.whoi.edu/api/nut/' cruises{count1} '.csv']);
        %opt.VariableTypes(strcmp(opt.VariableNames, 'alternate_sample_id')) = {'char'};
        %opt.Timeout = 120;
        nut = webread(['https://nes-lter-data.whoi.edu/api/nut/' cruises{count1} '.csv'], opt);
        catch
            disp([cruises{count1} 'no data found'])
            disp('no data found')
    end
    if exist('nut','var')
    writetable(nut,['\\sosiknas1\Lab_data\LTER\NUT\API_products\' cruises{count1} '_nut.csv'])
    end
    clear nut
end


for count1 = 1:length(cruises)
    disp(cruises{count1})
    opt = weboptions('Timeout', 120);
    try
        %opt = detectImportOptions(['https://nes-lter-data.whoi.edu/api/nut/' cruises{count1} '.csv']);
        %opt.VariableTypes(strcmp(opt.VariableNames, 'alternate_sample_id')) = {'char'};
        %opt.Timeout = 120;
        bottles = webread(['https://nes-lter-data.whoi.edu/api/ctd/' cruises{count1} '/bottles.csv'], opt);
        catch
            disp(cruises{count1})
            disp('no data found')
            bottles = table(nan);
    end
    writetable(bottles,['D:\API_bottles\' cruises{count1} '_ctd_bottles.csv'])
end
