[chl,header_chl] = importNESLTERchlxlsALL('\\sosiknas1\Lab_data\LTER\CHL\NESLTERchl.xlsx');

[LTERsamplelog, header] = importLTER_sample_log('\\sosiknas1\Lab_data\LTER\LTER_sample_log.xls');
LTERsamplelog.NiskinTargetDepth(LTERsamplelog.NiskinTargetDepth == 'Surface') = categorical(1.9);
LTERsamplelog.NiskinTargetDepth(LTERsamplelog.NiskinTargetDepth == 'surface') = categorical(1.9);

for count = 1:size(chl,1)
    samplelogROW = find(LTERsamplelog.Cruise == chl.Cruise(count) & LTERsamplelog.Cast == chl.Cast(count) & LTERsamplelog.Niskin == chl.Niskin(count) & LTERsamplelog.CastType == 'C');
     if ~isempty(samplelogROW)
         chl.target_depth(count) = LTERsamplelog.NiskinTargetDepth(samplelogROW);
     end
end

% writetable(chl,'NESLTER_chl_wdepth.csv')
writetable(chl,'NESLTER_chl_wdepth.xls')