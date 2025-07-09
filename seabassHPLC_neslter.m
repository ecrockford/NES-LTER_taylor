%TCrockford 3Dec2021
%Submissions must be a single file per cruise which is
%slightly different than MVCO. there is an online GFSP form to try and use
%but Taylor couldn't get it to work with the 2019 excel file from Crystal...
%all NES-LTER HPLC data run by Crystal Thomas at Goddard/NASA

%%%%%%%%%%%%%QUESTIONS
%looks like GFSP duplicates 0.5's aren't included in main spreadsheet anymroe so don't need to worry about excluding them
%quality flag - we don't have any QC right now....

clear all, close all

%choose revision# for .sb files created. Will only be greater than 1 if
%files were previously submitted to seabass. Choosing XXXX is for test runs
%or if you want to manually edit both the file name and header line
answer = input('Do you want to enter a specific revision number? Answer y or n \n','s');
switch answer
    case {'y','Y','yes'}
        fprintf('\n');
        fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        fprintf('\n');
        fprintf('This number will be written in the file name and each file header field data_file_name. \n \n');
        fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        fprintf('\n');
        revisions_number = input('Enter the revision number: ','s');
        fprintf('\n');
    case {'n','N','no'}
        fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        fprintf('\n');
        fprintf('No ver # was selected so temporary space filler of XXXX will be used. \n \n');
        fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        fprintf('\n');
        revisions_number = 'XXXX';
    otherwise
        fprintf('\n');
        error('\n\nYour answer was not valid.');
end
disp(['Revision output will be: ' revisions_number])

%this mat file created by running 
% \\sosiknas1\Lab_data\LTER\code\HPLC_LTER.m
load \\sosiknas1\Lab_data\LTER\HPLC\data\NESLTER_HPLC_data.mat

datadir = '\\sosiknas1\Lab_data\LTER\HPLC\data\';
investigators = 'Heidi_Sosik';
contact = 'hsosik@whoi.edu,lter-nes-info@whoi.edu,ecrockford@whoi.edu';
data_status = 'final'; 
experiment = 'NES-LTER';
station = 'NA';
%BDL (below detection limit) already foramtted for seabass as -888 when get from Goddard

%format date/time the way they want in individual columns
HPLC.date = datestr(HPLC.matdate,'yyyymmdd');
HPLC.time = datestr(HPLC.matdate,'HH:MM:SS');
HPLC.Volumefilteredml=HPLC.Volumefilteredml/1000; %seabass insists volume filt units be L

%deal with wanting 1 decimal precision of depth. without this line
%somethign like 27.5 will carry through but 3.0 will turn to just 3 in csv
HPLC.depth = strtrim(cellstr(num2str(HPLC.depth,'%0.1f')));

%loop through each cruise to make a separate data file
%loop also writes cruise specific documents in documents header field
%loop check if Pioneer cruise, adds comment if yes
unq_cruise_list = unique(HPLC.cruise);
for cruisecount = 1:length(unq_cruise_list)
    %separate each cruise for a new seabass file
    data = HPLC(HPLC.cruise == unq_cruise_list(cruisecount),:); 
    cruise = char(unq_cruise_list(cruisecount));
    
    %keep appropriate variables
    keep =  ["cast" "niskin" "date" "time" "Latitude" "Longitude" "depth" "HSL_id" "GSFC_id" "Volumefilteredml" HPLC.Properties.VariableNames(22:62)];
    HPLC2use = data(:,keep);
    
    %check what cruise and make documents header field entry
    pioneer_cruises = {'AR28B','AR31A','AR34B','AR39B','AR61B','AR66B'};
    spiropa_cruises = {'AR29','RB1907','TN368'};
    switch cruise
        case {'AR28B','AR31A','EN608','EN617','EN627'}
            original_file = 'Sosik08-15report.xlsx';
            documents = [original_file ',checklist_hplc_' cruise '.rtf,HPLC_Sosik_sampling_protocol.pdf,HPLC_method_summary_ver2020.pdf'];
        case {'AR34B','AR39B','AR61B', 'AR66B', 'AT46', 'EN644','EN649','EN655','EN657','EN661','EN668', 'EN687', 'TN368'}
            original_file = 'Sosik_12-08_report.xlsx';
            documents = [original_file ',checklist_hplc_' cruise '.rtf,HPLC_Sosik_sampling_protocol.pdf,HPLC_method_summary_SeaBASS_updated10032021.doc'];
%             calibration_files = '';
        case {'AR77','EN695','EN706','HRS2303'}
            original_file = 'Sosik_13-07_report.xlsx';
            documents = [original_file ',checklist_hplc_' cruise '.rtf,HPLC_Sosik_sampling_protocol.pdf,HPLC_method_summary_SeaBASS_updated10032021.doc'];
        otherwise
            error('Cruise needs to be added to the switch clause in the code. If a Pioneer cruise, confirm it is in the variable list above pioneer_cruises.')
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    bassfile = ['NES-LTER_' cruise '_HPLC_' datestr(data.matdate(1),'yyyymmdd_HHMM') '_R' revisions_number '.sb'];
    header_filename = [datadir 'seabass\headers\header_NES-LTER_HPLC_' cruise '.txt'];
    table_filename = [datadir 'seabass\tables\datatable_NES-LTER_HPLC_' cruise '.csv'];
    final_filename = [datadir 'seabass\' bassfile];
    
    disp(bassfile)
   
    %STEP 1 of making .sb file, make table csv file
    writetable(HPLC2use,table_filename,'writevariablenames',false);
%%%%%%%%%%%%%%station_alt_id%%%%%%%%%%%% to label our NES-LTER staiton? 
    fields_list = 'station,bottle,date,time,lat,lon,depth,sample,hplc_gsfc_id,volfilt,Tot_Chl_a,Tot_Chl_b,Tot_Chl_c,alpha-beta-Car,But-fuco,Hex-fuco,Allo,Diadino,Diato,Fuco,Perid,Zea,MV_Chl_a,DV_Chl_a,Chlide_a,MV_Chl_b,DV_Chl_b,Chl_c1c2,Chl_c3,Lut,Neo,Viola,Phytin_a,Phide_a,Pras,Gyro,Tchl,PPC,PSC,PSP,Tcar,Tacc,Tpg,DP,Tacc_Tchla,PSC_Tcar,PPC_Tcar,TChl_Tcar,PPC_Tpg,PSP_Tpg,Tchla_Tpg'; %,quality';
    %CURRENT UNITS FOR 'NONE' OF 7 DOESN'T INCLUDE QUALITY FLAG
    units_list = ['none,none,yyyymmdd,hh:mm:ss,degrees,degrees,m,none,none,L' repmat(',mg/m^3',1,34) repmat(',none',1,7)]; %IF ADD QUALITY FLAG MUST ADD A NONE
%{
    %if loop not necessary right now, but if there's a processing lab change or change in file format need to account    
% processing_lab_change_date = datenum('08/12/2010','mm/dd/yyyy');
if matdate(ind(1)) < processing_lab_change_date
    processing_center = 'HPLC samples analyzed at the NASA Goddard OBPG HPLC Lab by Crystal Thomas';
    fields_list = 'station,bottle,date,time,lat,lon,depth,sample,hplc_gsfc_id,volfilt,Tot_Chl_a,Tot_Chl_b,Tot_Chl_c,alpha-beta-Car,But-fuco,Hex-fuco,Allo,Diadino,Diato,Fuco,Perid,Zea,MV_Chl_a,DV_Chl_a,Chlide_a,MV_Chl_b,DV_Chl_b,Chl_c1,Chl_c2,Chl_c1c2,Chl_c3,Lut,Neo,Viola,Phytin_a,Phide_a,Pras,Gyro,Tchl,PPC,PSC,PSP,Tcar,Tacc,Tpg,DP,Tacc_Tchla,PSC_Tcar,PPC_Tcar,TChl_Tcar,PPC_Tpg,PSP_Tpg,Tchla_Tpg,mPF,nPF,pPF,quality';
else
    processing_center = 'HPLC samples analyzed at the NASA Goddard OBPG HPLC Lab by Crystal Thomas';
    fields_list = 'depth,number,sample,hplc_gsfc_id,Tot_Chl_a,Tot_Chl_b,Tot_Chl_c,alpha-beta-Car,But-fuco,Hex-fuco,Allo,Diadino,Diato,Fuco,Perid,Zea,MV_Chl_a,DV_Chl_a,Chlide_a,MV_Chl_b,DV_Chl_b,Chl_c1,Chl_c2,Chl_c1c2,Chl_c3,Lut,Neo,Viola,Phytin_a,Phide_a,Pras,Gyro,Tchl,PPC,PSC,PSP,Tcar,Tacc,Tpg,DP,Tacc_Tchla,PSC_Tcar,PPC_Tcar,TChl_Tcar,PPC_Tpg,PSP_Tpg,Tchla_Tpg,mPF,nPF,pPF,quality';
end
%}

%STEP 2 of making .sb file, make header text file
%doi identifier and received date added by seabass staff post-submission
%very specific header format required for seabass files. cannot be any
%spaces in lines excep for commented lines beginning with !
fid=fopen(header_filename,'w');
fprintf(fid,'/begin_header\n');
fprintf(fid,'/data_file_name=%-s\n',bassfile);
fprintf(fid,'/affiliations=Woods_Hole_Oceanographic_Institution\n');
fprintf(fid,'/investigators=%-s\n',investigators);
fprintf(fid,'/contact=%-s\n',contact);
fprintf(fid,'/experiment=%-s\n',experiment);
fprintf(fid,'/cruise=%-s\n',cruise);
fprintf(fid,'/data_type=pigment\n');
fprintf(fid,'/data_status=%-s\n',data_status);
fprintf(fid,'/original_file_name=%-s\n',original_file);
fprintf(fid,'/documents=%s\n',documents);
fprintf(fid,'/calibration_files=no_cal_files\n');
fprintf(fid,'/north_latitude=%-3.4f[DEG]\n',max(data.Latitude));
fprintf(fid,'/south_latitude=%-3.4f[DEG]\n',min(data.Latitude));
fprintf(fid,'/east_longitude=%-3.4f[DEG]\n',max(data.Longitude));
fprintf(fid,'/west_longitude=%-3.4f[DEG]\n',min(data.Longitude));
fprintf(fid,'/start_date=%-8s\n',datestr(min(data.matdate),'yyyymmdd'));
fprintf(fid,'/end_date=%-8s\n',datestr(max(data.matdate),'yyyymmdd'));
fprintf(fid,'/start_time=%-8s[GMT]\n',datestr(min(data.matdate),'HH:MM:SS'));
fprintf(fid,'/end_time=%-8s[GMT]\n',datestr(max(data.matdate),'HH:MM:SS'));
fprintf(fid,'/water_depth=NA\n');
fprintf(fid,'/HPLC_lab=NASA_GSFC\n');
fprintf(fid,'/HPLC_lab_technician=Crystal_Thomas\n');
if any(strcmp(cruise,pioneer_cruises))
    fprintf(fid,'!\n');
    fprintf(fid,'!NES-LTER participated as ancillary science on an Ocean Observatories Initiative New England Pioneer Array service cruise funded by the National Science Foundation under Cooperative Agreement No. 1743430.\n');
    fprintf(fid,'!\n');
end
if any(strcmp(cruise,spiropa_cruises))
    fprintf(fid,'!\n');
    fprintf(fid,'!These data were collected for NES-LTER on a Shelfbreak Productivity Interdisciplinary Research Operation at the Pioneer Array (SPIROPA) cruise funded by the National Science Foundation OCE-1657803.\n');
    fprintf(fid,'!Additional information on the SPIROPA project can be found at http://science.whoi.edu/users/olga/SPIROPA/SPIROPA.html and https://www.bco-dmo.org/project/748894\n');
    fprintf(fid,'!\n');
end
%     fprintf(fid,'!\n');
%     fprintf(fid,'! Analyst-specific quality control 1 = no suspicion; 2 = some question, high replicate variability; 3 = very suspicious\n');
%     fprintf(fid,'!\n');
fprintf(fid,'/missing=-9999\n');
fprintf(fid,'/below_detection_limit=-8888\n');
fprintf(fid,'/delimiter=comma\n');
fprintf(fid,'/fields=%-s\n',fields_list);
fprintf(fid,'/units=%-s\n',units_list); 
fprintf(fid,'/end_header\n');
fclose(fid);


%STEP 3, combine header and table into single .sb file to be submitted

%%%%%WRITING OPTION 1%%%%%%%%%%%
%%%actually using a Windows command, Joe F advised this code could cause
%%%probablems depending on what OS and what computer it's used on. fwrite
%%%is safer bet

%https://www.mathworks.com/matlabcentral/answers/10916-combine-multiple-text-files-into-one-text-file
% system(['copy/b ' header_filename '+' table_filename ' ' final_filename])

%%%%%%%%%%%%WRITING OPTION 2%%%%%%%%%%%%%
%%%%as far as I can tell this fwrit-ing is the same output as system with copy/b command%%%%%%%%%%%
%https://www.mathworks.com/matlabcentral/answers/345240-how-to-merge-text-files-into-one-file
fidOut = fopen(final_filename,'w');
fid=fopen(header_filename,'r');
fwrite(fidOut,fread(fid,'*char'),'*char');
fclose(fid);
fid=fopen(table_filename,'r');
fwrite(fidOut,fread(fid,'*char'),'*char');
fclose(fid);
fclose(fidOut);


%{
%write all the fields to the seabass text file line by line. i tried to
%just add the entire matrix all at once (ex-56x46 matrix with event,
%matdate etc as long 56x1 columns at the beginning) but very ugly things
%happened. below is very unellegant except it gets the job done and it's
%only 1 file so whatever. 

%you cannot use cells with fprintf everything is converted from the raw
%cell data to either char(%s) or double(%f)
%         fprintf(fid,'%i %i %8f %8s %2.3f $2.3f %-3.1f %-5s %s %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %1f\n'...
%     fields_list = 'station,bottle,date,time,lat,lon,depth,sample,hplc_gsfc_id,volfilt,Tot_Chl_a,Tot_Chl_b,Tot_Chl_c,alpha-beta-Car,But-fuco,Hex-fuco,Allo,Diadino,Diato,Fuco,Perid,Zea,MV_Chl_a,DV_Chl_a,Chlide_a,MV_Chl_b,DV_Chl_b,Chl_c1c2,Chl_c3,Lut,Neo,Viola,Phytin_a,Phide_a,Pras,Gyro,Tchl,PPC,PSC,PSP,Tcar,Tacc,Tpg,DP,Tacc_Tchla,PSC_Tcar,PPC_Tcar,TChl_Tcar,PPC_Tpg,PSP_Tpg,Tchla_Tpg,quality';
%     units_list = ['none,none,yyyymmdd,hh:mm:ss,degrees,degrees,m,none,none,L,' repmat('mg/m^3,',1,26) repmat('none,',1,15) 'none\n']; %last none is for quality flag. will we include it?
% 
% 
% for count = 1:length(ind)
%         fprintf(fid,'%-3.1f %0.0f %-5s %s %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %1f\n'...
%             ,depth(ind(count)), replicate(ind(count)), cell2mat(HSno(ind(count))), cell2mat(hpl_id(ind(count))), data(ind(count),1), data(ind(count),2), data(ind(count),3), data(ind(count),4),...
%             data(ind(count),5),data(ind(count),6), data(ind(count),7), data(ind(count),8), data(ind(count),9), data(ind(count),10), data(ind(count),11), data(ind(count),12), data(ind(count),13),...
%             data(ind(count),14), data(ind(count),15), data(ind(count),16), data(ind(count),17), data(ind(count),18), data(ind(count),19), data(ind(count),20), data(ind(count),21), data(ind(count),22),...
%             data(ind(count),23), data(ind(count),24), data(ind(count),25), data(ind(count),26), data(ind(count),27), data(ind(count),28), data(ind(count),29), data(ind(count),30), data(ind(count),31),...
%             data(ind(count),32), data(ind(count),33), data(ind(count),34), data(ind(count),35), data(ind(count),36), data(ind(count),37), data(ind(count),38), data(ind(count),39), data(ind(count),40),...
%             data(ind(count),41), data(ind(count),42), data(ind(count),43), data(ind(count),44), data(ind(count),45), data(ind(count),46), quality(ind(count)));
% end
%}
end