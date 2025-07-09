% NUT flag
% Bofu & Taylor
% Mar. 25 2024
%
% API nut files have been downloaded previously with another script to a local dir
% loop through files (by cruise). calculate and apply flags 
% write new file with ratio, diff, and flag. files same name as input, in diff dir
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

clear all

% filepath  =  '/Users/warrbob/Desktop/WHOI/research/NUT_API_products/';  % path to your raw nutrient files for each cruise
% filepath_flag  =  '/Users/warrbob/Desktop/WHOI/research/NUT_API_products/flagged/';  % path to the save folder of your flagged nutrient files for each cruise
filepath = '\\sosiknas1\Lab_data\LTER\NUT\API_products\';
filepath_flag  =  '\\sosiknas1\Lab_data\LTER\NUT\QC\flagged\';


dd0 = dir([filepath '*nut.csv']);
for i = 1:length(dd0)  % loop through each nutrient file
    filename  =  dd0(i).name;   % get file name
    disp(filename)
    filein    =  [filepath filename];  
    datain = readtable(filein,'FileType','text');% load file
    if size(datain,1)>0  % if there are data in this file
        time = datenum(datain.date,'yyyy-mm-dd HH:MM:SS');
        depth = datain.depth;
        nitrate_nitrite = datain.nitrate_nitrite;
        ammonium = datain.ammonium;
        phosphate = datain.phosphate;
        silicate = datain.silicate;

        nitrate_nitrite(find(datain.nitrate_nitrite <= 0.04)) = 0.04;  % set values below the detection limit to the detection limit
        ammonium(find(datain.ammonium <= 0.01)) = 0.01;
        phosphate(find(datain.phosphate <= 0.009)) = 0.009;
        silicate(find(datain.silicate <= 0.03)) = 0.03;

        % set up matrix for ratios
        nitrate_nitrite_ratio = nan(size(time));
        ammonium_ratio = nan(size(time));
        phosphate_ratio = nan(size(time));
        silicate_ratio = nan(size(time));
        nitrate_nitrite_diff = nan(size(time));
        ammonium_diff = nan(size(time));
        phosphate_diff = nan(size(time));
        silicate_diff = nan(size(time));

        for j = 1:length(time)
            ind = find(time == time(j));
            %following line is original to Bofu's code but does not
            %actually find the replicate
%             ind(find(ind == j)) = [];  % ind will be the other relicate
            ind = find(abs(time-time(j))<1/24/60 & abs(depth-depth(j))<3);
            ind = ind(ind ~= j);
            if ~isempty(ind)
%             if abs(time(ind)-time(j))<1/24/60 & abs(depth(ind)-depth(j))<3  % indicating they are replicate to each other using depth & time constraints
                nitrate_nitrite_ratio(j) = 100*(nitrate_nitrite(j)-mean(nitrate_nitrite([ind' j])))./mean(nitrate_nitrite([ind' j])); % calculating ratio
                ammonium_ratio(j) = 100*(ammonium(j)-mean(ammonium([ind' j])))./mean(ammonium([ind' j]));
                phosphate_ratio(j) = 100*(phosphate(j)-mean(phosphate([ind' j])))./mean(phosphate([ind' j]));
                silicate_ratio(j) = 100*(silicate(j)-mean(silicate([ind' j])))./mean(silicate([ind' j]));
                nitrate_nitrite_diff(j) = diff(nitrate_nitrite([ind(1) j]));
                ammonium_diff(j) = diff(ammonium([ind(1) j]));
                phosphate_diff(j) = diff(phosphate([ind(1) j]));
                silicate_diff(j) = diff(silicate([ind(1) j]));
            end
        end

        % put ratios into matrix
        datain.nitrate_nitrite_ratio = nitrate_nitrite_ratio;
        datain.ammonium_ratio = ammonium_ratio;
        datain.phosphate_ratio = phosphate_ratio;
        datain.silicate_ratio = silicate_ratio;
        datain.nitrate_nitrite_diff = nitrate_nitrite_diff;
        datain.ammonium_diff = ammonium_diff;
        datain.phosphate_diff = phosphate_diff;
        datain.silicate_diff = silicate_diff;

        %add first round auto-flagging
        %NO3, Si, P - questionable flag=3 >15%;
        %NO3, Si, P - bad flag=4 >40%
        %NH4 - questionable flag=3 >20%;
        %NH4 - bad flag=4 >50%
        datain.flag_nitrate_nitrite = ones(size(time));
        datain.flag_nitrate_nitrite(isnan(datain.nitrate_nitrite_ratio)) = 2;
        datain.flag_nitrate_nitrite(abs(datain.nitrate_nitrite_ratio) > 15) = 3;
        datain.flag_nitrate_nitrite(abs(datain.nitrate_nitrite_ratio) > 40) = 4;
        datain.flag_ammonium = ones(size(time));
        datain.flag_ammonium(isnan(datain.ammonium_ratio)) = 2;
        datain.flag_ammonium(abs(datain.ammonium_ratio) > 20) = 3;
        datain.flag_ammonium(abs(datain.ammonium_ratio) > 50) = 4;
        datain.flag_phosphate = ones(size(time));
        datain.flag_phosphate(isnan(datain.phosphate_ratio)) = 2;
        datain.flag_phosphate(abs(datain.phosphate_ratio) > 15) = 3;
        datain.flag_phosphate(abs(datain.phosphate_ratio) > 40) = 4;
        datain.flag_silicate = ones(size(time));
        datain.flag_silicate(isnan(datain.silicate_ratio)) = 2;
        datain.flag_silicate(abs(datain.silicate_ratio) > 15) = 3;
        datain.flag_silicate(abs(datain.silicate_ratio) > 40) = 4;
    end
    writetable(datain,[filepath_flag filename]);   % save file
end