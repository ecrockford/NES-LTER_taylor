%1st step of lter nut flagging doesn't work well for low concentrations. 
%this 2nd step changes flag=4(bad) to flag=3(caution) to be more lenient. 
%next step is manual inspection of all flagged data
%do not want to be too lenient and change flags to 1(good) because good will not be manually inspected
%
%2nd step = if both replicates are less than DetectionLimit * 10, then change from bad to caution
%Detection Limit (DL) is nutrient specific

%
% Flagging scheme based on IODE flag
% 1 = good
% 2 = not reviewed
% 3 = questionable
% 4 = bad (always throw out)
% 
% Detection Limit diff for each nutrient
% nitrate_nitrite = 0.04
% ammonium = 0.015
% phosphate = 0.009
% silicate = 0.030

% datadir  =  '\\sosiknas1\Lab_data\LTER\NUT\QC\flagged\';
datadirout = '\\sosiknas1\Lab_data\LTER\NUT\QC\flagged\step2\';
datafiles = dir([datadir '*nut.csv']);
% datafiles = {datafiles.name}';
    
    nut2check = {'nitrate_nitrite','ammonium','phosphate','silicate'};
    flag2check = {'flag_nitrate_nitrite','flag_ammonium','flag_phosphate','flag_silicate'};
    DL = [0.04; 0.015; 0.009; 0.030];

for count = 1:length(datafiles)
    filename  = datafiles(count).name;
    disp(filename)
    datain = readtable([datadir filename]);
    if ~isempty(datain)
        time = datenum(datain.date,'yyyy-mm-dd HH:MM:SS');
        for countnuttype = 1:4
            flagin = table2array(datain(:,flag2check(countnuttype)));
            nutin = table2array(datain(:,nut2check(countnuttype)));
        for count1 = 1:size(datain,1)
            if flagin(count1) == 4
            ind = find(abs(time-time(count1))<1/24/60 & abs(datain.depth-datain.depth(count1))<3);
            if length(ind)>1 && sum(nutin(ind)<(DL(countnuttype)*10))>1 && nutin(count1)<DL(countnuttype)*10
                flagin(count1) = 3;
            end
            clear ind
            end
        end
        datain(:,flag2check(countnuttype)) = table(flagin);
        end
        writetable(datain,[datadirout filename]);   % save file
    elseif isempty(datain)
        disp([filename ' is empty'])
    end
    clear countnuttype count1
end
