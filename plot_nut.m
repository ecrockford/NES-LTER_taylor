%Taylor 6/12/19
%import LTER nut data using downloaded API products which should all have same format
%

datadir = '\\sosiknas1\Lab_data\LTER\NUT\API_products\';
files = dir([datadir '*nut.csv']);
header_shouldbe = {'cruise','cast','niskin','date','latitude','longitude','depth','sample_id','replicate','nitrate_nitrite','ammonium','phosphate','silicate'};
data = [];
for count = 1:length(files)
    disp(files(count).name)
    filename = [datadir files(count).name];
    header = fxn_checkNUTheader(filename);
    if sum(strcmp(header, header_shouldbe)) == length(header_shouldbe)
        temp = fxn_importAPInutrients(filename);
        data = [data; temp];
    else error(['File: ' files(count).name ' header does not match expected header'])
    end
end
clear count temp header_shouldbe filename

cruise = data(:,1);
cast = cell2mat(data(:,2));
niskin = cell2mat(data(:,3));
nutrep = data(:,9);
inda=strmatch('a',nutrep);
% nutdata =  cell(length(inda), 19);
meta = cell(length(inda), 7);
nutpairs = nan(length(inda),10);
header_meta = header(1:7);
header_nutpair = {'sample_id_repa','nitrate_nitrite_repa','ammonium_repa','phosphate_repa','silicate_repa','sample_id_repb','nitrate_nitrite_repb','ammonium_repb','phosphate_repb','silicate_repb'};
for count = 1:length(inda)
%     nutdata(count,1:13) = data(inda(count),:);
    meta(count,:) = data(inda(count),1:7);
    nutpairs(count,1:5) = [cell2mat(data(inda(count),8)) cell2mat(data(inda(count),10:end))];
    ind = find(strcmp(cruise(inda(count)),cruise) & cast==cast(inda(count)) & niskin==niskin(inda(count)));
    if ~isempty(strmatch('b',nutrep(ind)))
        indb = strmatch('b',nutrep(ind));
%         nutdata(count,14:end) = data(ind(indb),8:end);
        nutpairs(count,6:10) = [cell2mat(data(ind(indb),8)) cell2mat(data(ind(indb),10:end))];
    end
end
clear count
%are there any nut where there's a repb but not a repa? The above code doesn't account for this
ids = [nutpairs(:,1); nutpairs(:,6)];
[missingids, ind_missing] = setdiff(cell2mat(data(:,8)),ids,'rows');
if ~isempty(missingids)
    for count = 1:length(ind_missing)
        if ~isempty(strmatch('b',nutrep(ind_missing(count))))
            nutpairs(ind_missing(count),6:10) = [cell2mat(data(ind_missing(count),8)) cell2mat(data(ind_missing(count),10:end))];
        else
            error(['Need to investigate the following nut ID#:  ' num2str(missingids(count))])
        end
    end
end

matdate = char(meta(:,4));
matdate = datenum(matdate(:,1:19));



NO3minmax=[floor(min(cell2mat(data(:,10)))) ceil(max(cell2mat(data(:,10))))];
NH4minmax=[floor(min(cell2mat(data(:,11)))) ceil(max(cell2mat(data(:,11))))];
PO4minmax=[floor(min(cell2mat(data(:,12)))) ceil(max(cell2mat(data(:,12))))];
Si2minmax=[floor(min(cell2mat(data(:,13)))) ceil(max(cell2mat(data(:,13))))];

figure
subplot(221)%nitrate
plot(nutpairs(:,2),nutpairs(:,7),'.','markersize',13)
hold on
line([0 30],[0 30],'color','k','linewidth',1,'linestyle','--')
axis([NO3minmax NO3minmax]); axis square
grid on
title('Nitrate + Nitrite')
xlabel('rep a','fontweight','bold'); ylabel('rep b','fontweight','bold');

subplot(222)%ammonium
plot(nutpairs(:,3),nutpairs(:,8),'.','markersize',13)
hold on
line([-0.5 10],[-0.5 10],'color','k','linewidth',1,'linestyle','--')
axis([NH4minmax NH4minmax]); axis square
grid on
title('Ammonium'); xlabel('rep a','fontweight','bold'); ylabel('rep b','fontweight','bold');

subplot(223)%phosphate
plot(nutpairs(:,4),nutpairs(:,9),'.','markersize',13)
hold on
line([0 3],[0 3],'color','k','linewidth',1,'linestyle','--')
axis([PO4minmax PO4minmax]); axis square
grid on
title('Phosphate'); xlabel('rep a','fontweight','bold'); ylabel('rep b','fontweight','bold');

subplot(224)%silicate
plot(nutpairs(:,5),nutpairs(:,10),'.','markersize',13)
hold on
line([0 20],[0 20],'color','k','linewidth',1,'linestyle','--')
axis([Si2minmax Si2minmax]); axis square
grid on
title('Silicate'); xlabel('rep a','fontweight','bold'); ylabel('rep b','fontweight','bold');

unq_cruise=unique(meta(:,1));
colormat = [1 1 0; 1 0 0; 0 0 1; 0 1 1; 1 0 1; .5 .5 .5; 0 .5 .5; .5 .5 0; .5 0 .5; .5 1 0; .5 .25 1; 1 .5 0; 1 0 .75; 1 0 .25; .25 1 .25; .3 0 1; .25 1 0; .25 0 0];
figure
for count=1:length(unq_cruise)
    ind = strmatch(unq_cruise(count),meta(:,1));
    subplot(221)%nitrate
    plot(nutpairs(ind,2),nutpairs(ind,7),'.','color',colormat(count,:),'markersize',13)
    hold on
    subplot(222)%ammonium
    plot(nutpairs(ind,3),nutpairs(ind,8),'.','color',colormat(count,:),'markersize',13)
    hold on
    subplot(223)%phosphate
    plot(nutpairs(ind,4),nutpairs(ind,9),'.','color',colormat(count,:),'markersize',13)
    hold on
    subplot(224)%silicate
    plot(nutpairs(ind,5),nutpairs(ind,10),'.','color',colormat(count,:),'markersize',13)
    hold on
end
subplot(221)%nitrate
line([0 30],[0 30],'color','k','linewidth',1,'linestyle','--')
axis([NO3minmax NO3minmax]); axis square; grid on
title('Nitrate + Nitrite'); xlabel('rep a','fontweight','bold'); ylabel('rep b','fontweight','bold');
subplot(222)%ammonium
line([-0.5 10],[-0.5 10],'color','k','linewidth',1,'linestyle','--')
axis([NH4minmax NH4minmax]); axis square; grid on
title('Ammonium'); xlabel('rep a','fontweight','bold'); ylabel('rep b','fontweight','bold');
subplot(223)%phosphate
line([0 3],[0 3],'color','k','linewidth',1,'linestyle','--')
axis([PO4minmax PO4minmax]); axis square; grid on
title('Phosphate'); xlabel('rep a','fontweight','bold'); ylabel('rep b','fontweight','bold');
subplot(224)%silicate
line([0 20],[0 20],'color','k','linewidth',1,'linestyle','--')
axis([Si2minmax Si2minmax]); axis square; grid on
title('Silicate'); xlabel('rep a','fontweight','bold'); ylabel('rep b','fontweight','bold');
subplot(223); legend(unq_cruise)

nutavg = [nanmean([nutpairs(:,2) nutpairs(:,7)],2) nanmean([nutpairs(:,3) nutpairs(:,8)],2) nanmean([nutpairs(:,4) nutpairs(:,9)],2) nanmean([nutpairs(:,5) nutpairs(:,10)],2)];
nutrange = [range([nutpairs(:,2) nutpairs(:,7)],2) range([nutpairs(:,3) nutpairs(:,8)],2) range([nutpairs(:,4) nutpairs(:,9)],2) range([nutpairs(:,5) nutpairs(:,10)],2)];
nut_percentrange = nutrange./nutavg*100;
figure('name','Histo Nut Replicate range/mean (%)')
subplot(221); hist(nut_percentrange(:,1), [0:5:max(nut_percentrange(:,1))]), ylabel('# of events'), xlabel('Replicate range / mean (%)'); title('Nitrate_nitrite')
subplot(222); hist(nut_percentrange(:,2), [0:5:max(nut_percentrange(:,2))]), ylabel('# of events'), xlabel('Replicate range / mean (%)'); title('Ammonium')
subplot(223); hist(nut_percentrange(:,3), [0:5:max(nut_percentrange(:,3))]), ylabel('# of events'), xlabel('Replicate range / mean (%)'); title('Phosphate')
subplot(224); hist(nut_percentrange(:,4), [0:5:max(nut_percentrange(:,4))]), ylabel('# of events'), xlabel('Replicate range / mean (%)'); title('Silicate')

figure( 'name','Nut replicate range / mean (%) over time')
subplot(221); plot(nut_percentrange(:,1),'.','markersize',10); ylabel('Nut rep range / mean (%)'); xlabel('Event index #'); title('Nitrate + Nitrite')
line([0 length(nut_percentrange)],[20 20],'color','k','linewidth',1,'linestyle','--')
subplot(222); plot(nut_percentrange(:,2),'.','markersize',10); ylabel('Nut rep range / mean (%)'); xlabel('Event index #'); title('Ammonium')
line([0 length(nut_percentrange)],[20 20],'color','k','linewidth',1,'linestyle','--')
subplot(223); plot(nut_percentrange(:,3),'.','markersize',10); ylabel('Nut rep range / mean (%)'); xlabel('Event index #'); title('Phosphate')
line([0 length(nut_percentrange)],[20 20],'color','k','linewidth',1,'linestyle','--')
subplot(224); plot(nut_percentrange(:,4),'.','markersize',10); ylabel('Nut rep range / mean (%)'); xlabel('Event index #'); title('Silicate')
line([0 length(nut_percentrange)],[20 20],'color','k','linewidth',1,'linestyle','--')
badNO3 = find(nut_percentrange(:,1)>20 | nut_percentrange(:,1)<0);
badNH4 = find(nut_percentrange(:,2)>20 | nut_percentrange(:,2)<0);
badPO4 = find(nut_percentrange(:,3)>20 | nut_percentrange(:,3)<0);
badSi2 = find(nut_percentrange(:,4)>20 | nut_percentrange(:,4)<0);

repmat('NO3+NO2',length(badNO3),1)
disp('events with high range for replicates')
disp({'nutrient','range/mean %', 'cruise','case','niskin','depth','id#a','id#b','nut_a','nut_b'})
badnut_percentrangeGT20 = [repmat({'NO3+NO2'},length(badNO3),1) meta(badNO3,1:3) meta(badNO3,7) num2cell(nut_percentrange(badNO3,1)) num2cell(nutpairs(badNO3,[1 6 2 7]))];
badnut_percentrangeGT20 = [badnut_percentrangeGT20; repmat({'NH4'},length(badNH4),1) meta(badNH4,1:3) meta(badNH4,7) num2cell(nut_percentrange(badNH4,2)) num2cell(nutpairs(badNH4,[1 6 3 8]))];
badnut_percentrangeGT20 = [badnut_percentrangeGT20; repmat({'PO4'},length(badPO4),1) meta(badPO4,1:3) meta(badPO4,7) num2cell(nut_percentrange(badPO4,3)) num2cell(nutpairs(badPO4,[1 6 4 9]))];
badnut_percentrangeGT20 = [badnut_percentrangeGT20; repmat({'Si2'},length(badSi2),1) meta(badSi2,1:3) meta(badSi2,7) num2cell(nut_percentrange(badSi2,4)) num2cell(nutpairs(badSi2,[1 6 5 10]))];





