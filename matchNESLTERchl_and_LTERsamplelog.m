[chl,header_chl] = importNESLTERchlxlsALL('\\sosiknas1\Lab_data\LTER\CHL\NESLTERchl.xlsx');

[LTERsamplelog, header] = importLTER_sample_log_updated('\\sosiknas1\Lab_data\LTER\LTER_sample_log.xlsx');
LTERsamplelog.NiskinTargetDepth(LTERsamplelog.NiskinTargetDepth == 'Surface') = categorical(1.9);
LTERsamplelog.NiskinTargetDepth(LTERsamplelog.NiskinTargetDepth == 'surface') = categorical(1.9);

cruises = unique(chl.Cruise);
rowcount = 1;
for count = 1:length(cruises)
    cruiserow = find(strcmp(chl.Cruise,cruises(count)));
%     cruiserow = find(strcmp(LTERsamplelog.Cruise,cruises(count)));
    unq_casts = unique(chl.Cast(cruiserow));
    for count2 = 1:length(unq_casts)
        castrow = find(LTERsamplelog.Cruise == cruises(count) & LTERsamplelog.Cast == unq_casts(count2));
        unq_depth = unique(LTERsamplelog.NiskinTargetDepth(castrow));
        for count3 = 1:length(unq_depth)
            samplelogROW = find(LTERsamplelog.Cruise == cruises(count) & LTERsamplelog.Cast == unq_casts(count2) & LTERsamplelog.NiskinTargetDepth == unq_depth(count3));
            if length(samplelogROW) == 1
                chlROW = find(chl.Cruise == cruises(count) & chl.Cast == unq_casts(count2) & chl.Niskin == LTERsamplelog.Niskin(samplelogROW) & chl.FilterSize == 0);
                newchl_cell(rowcount,:) = [LTERsamplelog.Cruise(samplelogROW) categorical(LTERsamplelog.Cast(samplelogROW)) LTERsamplelog.NiskinTargetDepth(samplelogROW) categorical(chl.Chlugl(chlROW)') categorical(chl.Phaeougl(chlROW)') categorical(chl.LabnotebookandPagenumber(chlROW)') categorical(chl.quality_flag(chlROW)') categorical(chl.Comments(chlROW)') categorical(chl.QC_d(chlROW)') categorical(LTERsamplelog.OOIchlaID(samplelogROW)) categorical(LTERsamplelog.OOIchlbID(samplelogROW))] 
                newchl_num(rowcount,:) = [LTERsamplelog.Cast(samplelogROW) double(LTERsamplelog.NiskinTargetDepth(samplelogROW)) chl.Chlugl(chlROW)' chl.Phaeougl(chlROW)' chl.quality_flag(chlROW)' chl.QC_d(chlROW)'] 
            elseif length(samplelogROW) >1
        if ~isnan(LTERsamplelog.ChlVolA(cruiserow(count2)))
            repa_row = find(strcmp(chl.Cruise,cruises(count)) & chl.Cast == LTERsamplelog.Cast(cruiserow(count2)) & chl.Niskin == LTERsamplelog.Niskin(cruiserow(count2)) & strcmp(chl.Replicate,'a') & chl.FilterSize == 0);
            cruise(rowcount) = 
        