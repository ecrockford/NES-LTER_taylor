p = '\\sosiknas1\Lab_data\LTER\DOC\EDI\';
DOCtable = readtable([p 'nes-lter-doc-transect.csv']);
p = '\\sosiknas1\Lab_data\LTER\DOC\';
DOCtable = renamevars(DOCtable,"doc","npoc");
DOCtable = renamevars(DOCtable,"dtn","tn");
DOCtable = renamevars(DOCtable,"sample_type","cast_type");

%make categoricals instead of arrays
DOCtable.cruise = categorical(DOCtable.cruise);
DOCtable.cast_type = categorical(DOCtable.cast_type); %change to sample_type when change made
% DOCtable.sample_type = categorical(DOCtable.sample_type); %change to sample_type when change made
DOCtable.replicate = categorical(DOCtable.replicate);
DOCtable.nearest_station = categorical(DOCtable.nearest_station);

%get rid of blanks
% DOCtable = DOCtable(DOCtable.cast_type == 'C',:);
DOCtable = DOCtable(DOCtable.cast_type ~= 'blank',:); %before EDI table just using python output which sometimes has C and sometimes cast
%for now just work with the 3 cruises we have. Manually make list so
%they're in seasonal water. When doing unique(doc.cruises) they come out in
%alphabetical order which puts spring first
cruises = unique(DOCtable.cruise);

%calculate season
[y,m] = datevec(DOCtable.date);
DOCtable.season(ismember(m,[1,2,12])) = categorical({'winter'}); %Jan Feb Dec
DOCtable.season(ismember(m,[3,4,5])) = categorical({'spring'}); %Mar Apr May
DOCtable.season(ismember(m,[6,7,8])) = categorical({'summer'}); % Jun Jul Aug
DOCtable.season(ismember(m,[9,10,11])) = categorical({'fall'}); %Sep Oct Nov 
DOCtable.season(DOCtable.cruise == 'EN720') = categorical({'summer'}); %Special exception for reshceduled 'summer' cruise at start of Sept
season = unique(DOCtable.season);
clear y m
theseasons = {'Winter','Spring','Summer','Fall'};
cruise_season = {'Winter 2022','Spring 2022','Summer 2022','Winter 2023','Spring 2023','Summer 2023','Fall 2023','Winter 2024','Spring 2024','Summer 2024','Fall 2024','Winter 2025'};

%on 10/5/22 for the 3 cruises, true range is 44.4-93.19
docrange = [45 105];
tnrange = [0 20];
ratiorange = [0 25];
saltrange = [31 37];
temprange = [0 30];

sampling_yrs = unique(year(DOCtable.date));

save([p 'DOCtable'])