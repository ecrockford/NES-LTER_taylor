
% p = 'C:\work\LTER\POC\';
p = '\\sosiknas1\Lab_data\LTER\CHN\data\';
NPPtable = readtable([p 'NESLTER_raw_npp_data_ALL_fromEDI20230208.csv']);

%get rid of everything except blanks and natrual abundance for POC at time
%zero to compare to Sosik values
NPPblanks = NPPtable(categorical(NPPtable.alternate_sample_category) == 'Filter_blank',:);
NPPtable = NPPtable(categorical(NPPtable.alternate_sample_category) == 'NatAbun',:);

C_atomic_wt = 12.0107; %g*mol^-1,  atomic weight of carbon
NPPtable.umolC = (NPPtable.massC_mg*1000)/12.0107;

% THIS DOESN'T WORK BECAUSE NOT FROM SAME NISKIN
matchup = [];
unq_cruise = unique(CHNtable.Cruise);
for cruise_count = 1:length(unq_cruise)
    cruise = CHNtable(categorical(CHNtable.Cruise) == unq_cruise(cruise_count),:);
    unq_cast = unique(cruise.Cast);
    for cast_count = 1:length(unq_cast)
        cast = cruise(cruise.Cast == unq_cast(cast_count),:);
        unq_niskin = unique(cast.Niskin_);
        for niskin_count = 1:length(unq_niskin)
            n_ind = find(cast.Niskin_ == unq_niskin(niskin_count));
            chnfind = cast(n_ind(1),:);
%             if length(Hpig) >1
%                 for pig_count = 1:length(HPLC_pigvar)
%                     Hpig(pig_count) = nanmean(Hpig(:,pig_count));
%                 end
%             end
            npp_ind = find(categorical(NPPtable.cruise) == unq_cruise(cruise_count) & NPPtable.cast == unq_cast(cast_count) & NPPtable.niskin == unq_niskin(niskin_count));
            if ~isempty(npp_ind)
                temp = [chnfind NPPtable.alternate_sample_category(npp_ind) NPPtable.replicate(npp_ind) NPPtable.vol_filt_L(npp_ind) NPPtable.massC_mg(npp_ind) NPPtable.umolC(npp_ind)];
%                 temp = [repmat(cast(n_ind(1),HPLC_metavar),length(chl_ind),1) repmat(Hpig,length(chl_ind),1) chl(chl_ind,chl_var2use)];
                matchup = [matchup; temp];
            end
            clear n_ind npp_ind temp
        end
        clear niskin_count unq_niskin cast
    end
    clear unq_cast cruise
end
