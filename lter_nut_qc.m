datadir = '\\sosiknas1\Lab_data\LTER\NUT\QC\flagged\';
datadir = '\\sosiknas1\Lab_data\LTER\NUT\QC\flagged\step2\';

datafiles = dir([datadir '*nut.csv']);
datafiles = {datafiles.name}';
nut = [];
emptyfiles = {};
var2use = {'cruise','cast','niskin','date','latitude','longitude','depth','sample_id','replicate','nitrate_nitrite','ammonium','phosphate','silicate','nitrate_nitrite_ratio','ammonium_ratio','phosphate_ratio','silicate_ratio','nitrate_nitrite_diff','ammonium_diff','phosphate_diff','silicate_diff','flag_nitrate_nitrite','flag_ammonium','flag_phosphate','flag_silicate'};
for count = 1:length(datafiles)
    temp = readtable([datadir char(datafiles(count))]);
    if ~isempty(temp)
%     nut = [nut; temp];
    nut = [nut; temp(:,var2use)];
    end
    if isempty(temp)
        emptyfiles = [emptyfiles; datafiles(count)];
        disp([char(datafiles(count)) ' is empty'])
    end
    clear temp
end
clear temp ans count

nut.replicate = categorical(nut.replicate);
nut.cruise = categorical(nut.cruise);
temp=char(nut.date);
nut.matdate = datenum(temp(:,1:19));
nut.datetime = datetime(temp(:,1:19));

[y,m] = datevec(nut.matdate);
nut.season(ismember(m,[1,2,12])) = categorical({'winter'});
nut.season(ismember(m,[3,4,5])) = categorical({'spring'});
nut.season(ismember(m,[6,7,8])) = categorical({'summer'});
nut.season(ismember(m,[9,10,11])) = categorical({'fall'});
season = unique(nut.season);



figure
subplot 221 %nitrate+nitrite
gscatter(1:length(nut.nitrate_nitrite_ratio),nut.nitrate_nitrite_ratio,nut.cruise)
xlabel('count','FontWeight','bold'); ylabel('ratio = (con - mean_con)/mean_con*100','FontWeight','bold'); title('Nitrate + Nitrite Ratio');
grid on;
line([0 3000],[15 15],'color','b','linestyle','--'); line([0 4500],[-15 -15],'color','b','linestyle','--');
line([0 3000],[40 40],'color','r','linestyle','--'); line([0 4500],[-40 -40],'color','r','linestyle','--');
subplot 222 %ammonium
gscatter(1:length(nut.ammonium_ratio),nut.ammonium_ratio,nut.cruise)
xlabel('count','FontWeight','bold'); ylabel('ratio = (con - mean_con)/mean_con*100','FontWeight','bold'); title('Ammonium Ratio');
grid on;
line([0 3000],[15 15],'color','b','linestyle','--'); line([0 4500],[-20 -20],'color','b','linestyle','--');
line([0 3000],[40 40],'color','r','linestyle','--'); line([0 4500],[-50 -50],'color','r','linestyle','--');
subplot 223 %phosephate
gscatter(1:length(nut.phosphate_ratio),nut.phosphate_ratio,nut.cruise)
xlabel('count','FontWeight','bold'); ylabel('ratio = (con - mean_con)/mean_con*100','FontWeight','bold'); title('Phosphate Ratio');
grid on;
line([0 3000],[15 15],'color','b','linestyle','--'); line([0 4500],[-15 -15],'color','b','linestyle','--');
line([0 3000],[40 40],'color','r','linestyle','--'); line([0 4500],[-40 -40],'color','r','linestyle','--');
subplot 224 %silicate
gscatter(1:length(nut.silicate_ratio),nut.silicate_ratio,nut.cruise)
xlabel('count','FontWeight','bold'); ylabel('ratio = (con - mean_con)/mean_con*100','FontWeight','bold'); title('Silicate Ratio');
grid on;
line([0 3000],[15 15],'color','b','linestyle','--'); line([0 4500],[-15 -15],'color','b','linestyle','--');
line([0 3000],[40 40],'color','r','linestyle','--'); line([0 4500],[-40 -40],'color','r','linestyle','--');


figure
subplot 221 %nitrate+nitrite
gscatter(nut.nitrate_nitrite,nut.nitrate_nitrite_ratio,nut.cruise)
xlabel('Concentration','FontWeight','bold'); ylabel('ratio = (con - mean_con)/mean_con*100','FontWeight','bold'); title('Nitrate + Nitrite Ratio');
grid on;
line([0 3000],[15 15],'color','b','linestyle','--'); line([0 4500],[-15 -15],'color','b','linestyle','--');
line([0 3000],[40 40],'color','r','linestyle','--'); line([0 4500],[-40 -40],'color','r','linestyle','--');
subplot 222 %ammonium
gscatter(nut.ammonium,nut.ammonium_ratio,nut.cruise)
xlabel('Concentration','FontWeight','bold'); ylabel('ratio = (con - mean_con)/mean_con*100','FontWeight','bold'); title('Ammonium Ratio');
grid on;
line([0 3000],[15 15],'color','b','linestyle','--'); line([0 4500],[-20 -20],'color','b','linestyle','--');
line([0 3000],[40 40],'color','r','linestyle','--'); line([0 4500],[-50 -50],'color','r','linestyle','--');
subplot 223 %phosephate
gscatter(nut.phosphate,nut.phosphate_ratio,nut.cruise)
xlabel('Concentration','FontWeight','bold'); ylabel('ratio = (con - mean_con)/mean_con*100','FontWeight','bold'); title('Phosphate Ratio');
grid on;
line([0 3000],[15 15],'color','b','linestyle','--'); line([0 4500],[-15 -15],'color','b','linestyle','--');
line([0 3000],[40 40],'color','r','linestyle','--'); line([0 4500],[-40 -40],'color','r','linestyle','--');
subplot 224 %silicate
gscatter(nut.silicate,nut.silicate_ratio,nut.cruise)
xlabel('Concentration','FontWeight','bold'); ylabel('ratio = (con - mean_con)/mean_con*100','FontWeight','bold'); title('Silicate Ratio');
grid on;
line([0 3000],[15 15],'color','b','linestyle','--'); line([0 4500],[-15 -15],'color','b','linestyle','--');
line([0 3000],[40 40],'color','r','linestyle','--'); line([0 4500],[-40 -40],'color','r','linestyle','--');
