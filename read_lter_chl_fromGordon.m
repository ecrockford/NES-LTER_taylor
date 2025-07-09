% This script is to read in LTER nutrient data
clear;

crslistfile = '~/research/roms/lter/data/nutrients/cruise_metadata_20220920.csv';
edifile     = '~/research/roms/lter/data/chl/nes-lter-chl-transect.csv';
csvfile{1}  = [];
apiaddress  = 'https://nes-lter-data.whoi.edu/api/chl/';

dz          = 1; % depth interval for final interpolation of the data

% read the cruise list so far
crslistdata = readtable(crslistfile);
ltercrslist = table2array(crslistdata(:,1));

% read the EDI file first
dtable      = readtable(edifile);
edicruise   = table2array(dtable(:,1));
cast        = table2array(dtable(:,2));
niskin      = table2array(dtable(:,3));
time        = table2array(dtable(:,5));
lat         = table2array(dtable(:,6));
lon         = table2array(dtable(:,7));
depth       = table2array(dtable(:,8));
replica     = table2array(dtable(:,10));
chl         = table2array(dtable(:,13));
projid      = table2array(dtable(:,16));

castdata = [];
icast    = 0;
% go through each cruise
[ucrs,IAcrs,ICcrs] = unique(edicruise);
for ic = 1:length(ucrs)
    cind = find(ICcrs == ic);

    ccast    = cast(cind);
    cniskin  = niskin(cind);
    ctime    = time(cind);
    clat     = lat(cind);
    clon     = lon(cind);
    cdepth   = depth(cind);
    creplica = replica(cind);
    cchl     = chl(cind);
    cprojid  = projid(cind);

    % go through each cast
    [ucast,IAcast,ICcast] = unique(ccast);
    for id = 1:length(ucast)
        if ~isnan(ucast(id))
            dind = find(ICcast == id);

            tcasttime    = ctime(dind(1));
            tcastdepth   = cdepth(dind);
            tcastreplica = creplica(dind);

            tcastchl  = cchl(dind);
            % remove/merge the replica
            [edepth,IAdpth,ICdpth] = unique(tcastdepth);
            nvalue       = [];
            ndepth       = [];
            iee          = 0;
            if length(edepth)>2
                for ie = 1:length(edepth)
                    eind = find(ICdpth == ie);
                    if length(eind)>1
                        tnvalues = tcastchl(eind);
                        if (std(tnvalues) <= 0.5*mean(tnvalues,'omitnan')) && (std(tnvalues)<=3)
                            % only consider the samples with STD of the replica is less than 50% of the mean
                            iee         = iee + 1;
                            nvalue(iee) = mean(tnvalues,'omitnan');
                            ndepth(iee) = edepth(ie);
                        end
                    elseif length(eind)==1
                        iee         = iee + 1;
                        nvalue(iee) = tcastchl(eind);
                        ndepth(iee) = edepth(ie);
                    end
                end
            end
            if length(nvalue) > 2
                % only consider the profiles having more than 2 valid samples
                icast = icast + 1;
                castdata{icast}.depth  = ndepth;
                castdata{icast}.chl    = nvalue;
                castdata{icast}.cruise = lower(ucrs{ic});
                castdata{icast}.cast   = ucast(id);
                castdata{icast}.time   = mean(ctime(dind),'omitnan');
                castdata{icast}.lon    = mean(clon(dind),'omitnan');
                castdata{icast}.lat    = mean(clat(dind),'omitnan');
                castdata{icast}.projid = cprojid{dind(1)};

%                 figure(1);
%                 plot(castdata{icast}.chl,-castdata{icast}.depth,'^-k');
%                 ylim([-150 0]);
%                 title([castdata{icast}.cruise ', Cast ' num2str(castdata{icast}.cast) '; icast = ' num2str(icast) ' Project ID: ' castdata{icast}.projid]);
%                 hold on;
% 
%                 figure(2);
%                 plot(castdata{icast}.lon,castdata{icast}.lat,'.k');
%                 hold on;
            end
        end
    end
    disp(['Finished processing ' lower(ucrs{ic}) ' chl data from the NES EDI file.']);
%     if strcmp(lower(ucrs{ic}),'en627')
%         pause;
%     end
end

csvcrs = {};
% % read the local CSV files second
% for ic = 1:length(csvfile)
%     % go through each cruise
%     tcsvfile    = csvfile{ic};
%     dtable      = readtable(tcsvfile);
%     csvcrs(ic)  = table2array(dtable(1,1));
%     ccast       = table2array(dtable(:,2));
%     cniskin     = table2array(dtable(:,3));
%     ctime       = table2array(dtable(:,4));
%     clat        = table2array(dtable(:,5));
%     clon        = table2array(dtable(:,6));
%     cdepth      = table2array(dtable(:,7));
%     csampid     = table2array(dtable(:,8));
%     creplica    = table2array(dtable(:,9));
%     cchl     = table2array(dtable(:,10));
%     cprojid     = table2array(dtable(:,15));
% 
%     % go through each cast
%     [ucast,IAcast,ICcast] = unique(ccast);
%     for id = 1:length(ucast)
%         dind = find(ICcast == id);
%         tcasttime    = ctime{dind(1)};
%         tcastdepth   = cdepth(dind);
%         tcastsampid  = csampid(dind);
%         tcastreplica = creplica(dind);
% 
%         tcastchl  = cchl(dind);
%         % remove/merge the replica
%         [edepth,IAdpth,ICdpth] = unique(tcastdepth);
%         nvalue       = [];
%         ndepth       = [];
%         iee          = 0;
%         if length(edepth)>2
%             for ie = 1:length(edepth)
%                 eind = find(ICdpth == ie);
%                 if length(eind)>1
%                     tnvalues = tcastchl(eind);
%                     if (std(tnvalues) <= 0.5*mean(tnvalues,'omitnan')) && (std(tnvalues)<=3)
%                         % only consider the samples with STD of the replica is less than 50% of the mean
%                         iee         = iee + 1;
%                         nvalue(iee) = mean(tnvalues,'omitnan');
%                         ndepth(iee) = edepth(ie);
%                     end
%                 elseif length(eind)==1
%                     iee         = iee + 1;
%                     nvalue(iee) = tcastchl(eind);
%                     ndepth(iee) = edepth(ie);
%                 end
%             end
%         end
%         if length(nvalue) > 2
%             % only consider the profiles having more than 2 valid samples
%             icast = icast + 1;
%             castdata{icast}.depth  = ndepth;
%             castdata{icast}.chl = nvalue;
%             castdata{icast}.cruise = lower(csvcrs{ic});
%             castdata{icast}.cast   = ucast(id);
%             castdata{icast}.time   = tcasttime;
%             castdata{icast}.lon    = mean(clon(dind),'omitnan');
%             castdata{icast}.lat    = mean(clat(dind),'omitnan');
%             castdata{icast}.projid = cprojid{dind(1)};
% 
%             figure(1);clf;
%             plot(castdata{icast}.chl,-castdata{icast}.depth,'^-k');
%             ylim([-150 0]);
%             title([castdata{icast}.cruise ', Cast ' num2str(castdata{icast}.cast) '; icast = ' num2str(icast) ' Project ID: ' castdata{icast}.projid]);
%             hold on;
% 
%             figure(2);
%             plot(castdata{icast}.lon,castdata{icast}.lat,'.k');
%             hold on;
%         end
%     end
%     disp(['Finished processing ' lower(csvcrs{ic}) ' chl data from individual CSV file.']);
% 
% end

% find the cruises on the LTER list but not in the EDI or CSV datasets
inlist = [];
excrs  = ucrs;
for ic = 1:length(csvcrs)
    excrs{end+1} = csvcrs{ic};
end
for ilt = 1:length(ltercrslist)
    tltercrs = ltercrslist{ilt};
    for iu = 1:length(excrs)
        texcrs = excrs{iu};
        if strcmpi(tltercrs,texcrs)
            inlist = [inlist; ilt];
        end
    end
end
apicrs = ltercrslist;
apicrs(inlist) = [];

options = weboptions('ContentType', 'table');



for ia = 1:length(apicrs)
    mytable = [];
    figure(1);clf;
    try
        mytable = webread([apiaddress lower(apicrs{ia}) '.csv'], options);
        if ~isempty(mytable)
            disp(['Finished retrieving ' lower(apicrs{ia}) ' chl data from the NES API address!!!']);
        else
            disp(['Retrieved empty ' lower(apicrs{ia}) ' chl data from the NES API address!!!']);
        end
    catch
        disp(['!!!CANNOT retrieve ' lower(apicrs{ia}) ' chl data from the NES API address!!!']);
    end

    if ~isempty(mytable)
        % read the API data
        ccast        = table2array(mytable(:,2));
        cniskin      = table2array(mytable(:,3));
        ctime        = table2array(mytable(:,16));
        clat         = table2array(mytable(:,17));
        clon         = table2array(mytable(:,18));
        cdepth       = table2array(mytable(:,19));
        creplica     = table2array(mytable(:,4));
        cchl         = table2array(mytable(:,14));
        % go through each cast
        [ucast,IAcast,ICcast] = unique(ccast);
        for id = 1:length(ucast)
            dind = find(ICcast == id);

            tcasttime    = ctime{dind(1)};
            tcastdepth   = cdepth(dind);
            tcastreplica = creplica(dind);

            tcastchl  = cchl(dind);
            % remove/merge the replica
            [edepth,IAdpth,ICdpth] = unique(tcastdepth);
            nvalue     = [];
            ndepth     = [];
            iee        = 0;
            if length(edepth)>2
                for ie = 1:length(edepth)
                    eind = find(ICdpth == ie);
                    if length(eind)>1
                        tnvalues = tcastchl(eind);
                        if (std(tnvalues) <= 0.5*mean(tnvalues,'omitnan')) && (std(tnvalues)<=3)
                            % only consider the samples with STD of the replica is less than 50% of the mean
                            iee         = iee + 1;
                            nvalue(iee) = mean(tnvalues,'omitnan');
                            ndepth(iee) = edepth(ie);
                        end
                    elseif length(eind)==1
                        iee         = iee + 1;
                        nvalue(iee) = tcastchl(eind);
                        ndepth(iee) = edepth(ie);
                    end
                end
            end
            if length(nvalue) > 2
                % only consider the profiles having more than 2 valid samples
                icast = icast + 1;
                castdata{icast}.depth  = ndepth;
                castdata{icast}.chl    = nvalue;
                castdata{icast}.cruise = lower(apicrs{ia});
                castdata{icast}.cast   = ucast(id);
                castdata{icast}.time   = tcasttime;
                castdata{icast}.lon    = mean(clon(dind),'omitnan');
                castdata{icast}.lat    = mean(clat(dind),'omitnan');
%                 figure(1);
%                 plot(castdata{icast}.chl,-castdata{icast}.depth,'^-k');
%                 ylim([-150 0]);
%                 title([castdata{icast}.cruise ', Cast ' num2str(castdata{icast}.cast) '; icast = ' num2str(icast)]);
%                 hold on; 
% 
%                 figure(2);
%                 plot(castdata{icast}.lon,castdata{icast}.lat,'.k');
%                 hold on;
            end
        end
    end
end

% interpolate the data onto regular vertical grid
z       = [-200:dz:0]';
numz    = length(z);
numcast = length(castdata);
lon     = nan([1 numcast]);
lat     = nan([1 numcast]);
time    = nan([1 numcast]);
castid  = nan([1 numcast]);
cruise  = {};
projid  = {};
chl     = nan([numz numcast]);

for ii = 1:length(castdata)
    lon(ii)    = castdata{ii}.lon;
    lat(ii)    = castdata{ii}.lat;
    cruise{ii} = castdata{ii}.cruise;
    castid(ii) = castdata{ii}.cast;

    try 
        time(ii)   = datenum(castdata{ii}.time);
    catch
        % remove '+' sign in some of the time variables
        tctime     = castdata{ii}.time;
        plsind     = strfind(tctime,'+');
        if ~isempty(plsind)
            tctime = tctime(1:plsind-1);
            time(ii)   = datenum(tctime);
        else
            error('something wrong the time variable!');
        end
    end
    
    % fill the surface gap of the top most sample is shallower than 10 m
    tcdepth         = abs(castdata{ii}.depth);
    nnind           = find(~isnan(tcdepth));

    if length(nnind) >= 2
        tcchl           = castdata{ii}.chl;
        tcchl           = tcchl(nnind);
        tcdepth         = tcdepth(nnind);
        [scdepth,dpind] = sort(tcdepth);
        scchl           = tcchl(dpind);
        if scdepth(1)  <= 10 && scdepth(1) > 0
            scdepth     = [0 scdepth(:)'];
            scchl       = [scchl(1) scchl(:)'];
        end
        chl(:,ii)       = interp1(-scdepth,scchl,z);
    end
end



% for now only save when the new t-series is longer than the old one
% this is because the API server is unstable. I am trying to get the
% longest t-series by trying its again and again.
save(['lter_chl_' datestr(now,'yyyymmdd') '.mat'] ,'castdata','z','lon',...
    'lat','time','cruise','castid','chl');
