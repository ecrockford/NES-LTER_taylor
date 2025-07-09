%Taylor Crockford June 21, 2019
%messy gode to plot NESLTER chl data for QC


% load \\sosiknas1\Lab_data\LTER\code\NESLTERchl.mat

filename = '\\sosiknas1\Lab_data\LTER\CHL\NESLTER_chl_merged.csv';
[chl,header] = fxn_import_chl_cellarray_python_output_NESLTER_chl_merged(filename);


%EN608
% cruise = 'EN608';
% wswlim= [0 6 0 6]; lt10lim = [0 2 0 2]; gt5lim = [0 3.5 0 3.5]; gt20lim = [0 3.5 0 3.5];

%EN627
cruise = 'EN627';
wswlim= [0 5 0 5]; lt10lim = [0 5 0 5]; gt5lim = [0 6 0 6]; gt20lim = [0 4 0 4];
AMwatch = {'L2','L3','L6','L7','L10','L11','MVCO'}; %casts 7 8 16 17 24 26 
PMwatch = {'L1','L4','L5','L8','L9','u11c' }; %casts 3/4 12 13 19 22 29 45 

%EN617
% cruise = 'EN617';
% wswlim= [0 3 0 3]; lt10lim = [0 3 0 3]; gt5lim = [0 1 0 1]; gt20lim = [0 0.4 0 0.4];



data = chl(strcmp(cruise,chl(:,1)),:); 
%get rid of any data with flags of 3 for this plotting case
flag3 = find(cell2mat(data(:,12))~=3 & cell2mat(data(:,13))~=3);
data = data(flag3,:);

% figure('color','w','position',[23 57 1025 784])
figure('position',[23 57 1025 784])
subplot(221) %WSW
plot(cell2mat(data(cell2mat(data(:,5))==0,6)),cell2mat(data(cell2mat(data(:,5))==0,7)),'b.','markersize',13)
hold on; grid on
line([0 20],[0 20],'color','r','linewidth',1,'linestyle','--')
axis square; axis(wswlim)
title([char(cruise) ' - WSW Chl (mg m^{-3})']); xlabel('Rep a','fontweight','bold'); ylabel('Rep b','fontweight','bold');
subplot(222) %<10
plot(cell2mat(data(cell2mat(data(:,5))==10,6)),cell2mat(data(cell2mat(data(:,5))==10,7)),'b.','markersize',13)
hold on; grid on
line([0 20],[0 20],'color','r','linewidth',1,'linestyle','--')
axis square; axis(lt10lim)
title([char(cruise) ' - <10um Chl (mg m^{-3})']); xlabel('Rep a','fontweight','bold'); ylabel('Rep b','fontweight','bold');
subplot(223) %>5
plot(cell2mat(data(cell2mat(data(:,5))==5,6)),cell2mat(data(cell2mat(data(:,5))==5,7)),'b.','markersize',13)
hold on; grid on
line([0 20],[0 20],'color','r','linewidth',1,'linestyle','--')
axis square; axis(gt5lim)
title([char(cruise) ' - >5um Chl (mg m^{-3})']); xlabel('Rep a','fontweight','bold'); ylabel('Rep b','fontweight','bold');
subplot(224) %>20
plot(cell2mat(data(cell2mat(data(:,5))==20,6)),cell2mat(data(cell2mat(data(:,5))==20,7)),'b.','markersize',13)
hold on; grid on
line([0 20],[0 20],'color','r','linewidth',1,'linestyle','--')
axis square; axis(gt20lim)
title([char(cruise) ' - >20um Chl (mg m^{-3})']); xlabel('Rep a','fontweight','bold'); ylabel('Rep b','fontweight','bold');

%plot percent range. plot vs chl concentration just for something to plot against
figure('position',[23 57 1025 784])
subplot(221)%WSW
plot(cell2mat(data(cell2mat(data(:,5))==0,17)),cell2mat(data(cell2mat(data(:,5))==0,18)),'b.','markersize',13)
hold on; grid on
line([0 max(cell2mat(data(cell2mat(data(:,5))==0,17)))],[20 20],'color','r','linewidth',1,'linestyle','--')
title([char(cruise) '  WSW Chl - percent range']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Percent Range (%)','fontweight','bold');
subplot(222)%<10
plot(cell2mat(data(cell2mat(data(:,5))==10,17)),cell2mat(data(cell2mat(data(:,5))==10,18)),'b.','markersize',13)
hold on; grid on
line([0 max(cell2mat(data(cell2mat(data(:,5))==10,17)))],[20 20],'color','r','linewidth',1,'linestyle','--')
title([char(cruise) '  <10um Chl - percent range']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Percent Range (%)','fontweight','bold');
subplot(223)%>5
plot(cell2mat(data(cell2mat(data(:,5))==5,17)),cell2mat(data(cell2mat(data(:,5))==5,18)),'b.','markersize',13)
hold on; grid on
line([0 max(cell2mat(data(cell2mat(data(:,5))==5,17)))],[20 20],'color','r','linewidth',1,'linestyle','--')
title([char(cruise) '  >5um Chl - percent range']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Percent Range (%)','fontweight','bold');
subplot(224)%>20
plot(cell2mat(data(cell2mat(data(:,5))==20,17)),cell2mat(data(cell2mat(data(:,5))==20,18)),'b.','markersize',13)
hold on; grid on
line([0 max(cell2mat(data(cell2mat(data(:,5))==20,17)))],[20 20],'color','r','linewidth',1,'linestyle','--')
title([char(cruise) '  >20um Chl - percent range']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Percent Range (%)','fontweight','bold');


%only use if investigating different watches
%
AMwsw = data(cell2mat(data(:,5))==0 & ismember(data(:,4),AMwatch),:); 
PMwsw = data(cell2mat(data(:,5))==0 & ismember(data(:,4),PMwatch),:);
AMlt10 = data(cell2mat(data(:,5))==10 & ismember(data(:,4),AMwatch),:); 
PMlt10 = data(cell2mat(data(:,5))==10 & ismember(data(:,4),PMwatch),:);
AMgt5 = data(cell2mat(data(:,5))==5 & ismember(data(:,4),AMwatch),:); 
PMgt5 = data(cell2mat(data(:,5))==5 & ismember(data(:,4),PMwatch),:);
AMgt20 = data(cell2mat(data(:,5))==20 & ismember(data(:,4),AMwatch),:); 
PMgt20 = data(cell2mat(data(:,5))==20 & ismember(data(:,4),PMwatch),:);

WSWmax = max([ceil(max(cell2mat(AMwsw(:,6:7)))) ceil(max(cell2mat(PMwsw(:,6:7))))]);
LT10max = max([ceil(max(cell2mat(AMlt10(:,6:7)))) ceil(max(cell2mat(PMlt10(:,6:7))))]);
GT5max = max([ceil(max(cell2mat(AMgt5(:,6:7)))) ceil(max(cell2mat(PMgt5(:,6:7))))]);
GT20max = max([ceil(max(cell2mat(AMgt20(:,6:7)))) ceil(max(cell2mat(PMgt20(:,6:7))))]);

figure('position',[23 57 1025 784])
subplot(221)
plot(cell2mat(AMwsw(:,17)),cell2mat(AMwsw(:,18)),'b.','markersize',13)
hold on; grid on
plot(cell2mat(PMwsw(:,17)),cell2mat(PMwsw(:,18)),'r.','markersize',13)
line([0 max(cell2mat(data(cell2mat(data(:,5))==0,17)))],[20 20],'color','k','linewidth',1,'linestyle','--')
title([char(cruise) '  WSW Chl - percent range']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Percent Range (%)','fontweight','bold');
subplot(222)
plot(cell2mat(AMlt10(:,17)),cell2mat(AMlt10(:,18)),'b.','markersize',13)
hold on; grid on
plot(cell2mat(PMlt10(:,17)),cell2mat(PMlt10(:,18)),'r.','markersize',13)
line([0 max(cell2mat(data(cell2mat(data(:,5))==10,17)))],[20 20],'color','k','linewidth',1,'linestyle','--')
legend('AM watch','PM watch')
title([char(cruise) '  <10um Chl - percent range']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Percent Range (%)','fontweight','bold');
subplot(223)
plot(cell2mat(AMgt5(:,17)),cell2mat(AMgt5(:,18)),'b.','markersize',13)
hold on; grid on
plot(cell2mat(PMgt5(:,17)),cell2mat(PMgt5(:,18)),'r.','markersize',13)
line([0 max(cell2mat(data(cell2mat(data(:,5))==5,17)))],[20 20],'color','k','linewidth',1,'linestyle','--')
title([char(cruise) '  >5um Chl - percent range']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Percent Range (%)','fontweight','bold');
subplot(224)
plot(cell2mat(AMgt20(:,17)),cell2mat(AMgt20(:,18)),'b.','markersize',13)
hold on; grid on
plot(cell2mat(PMgt20(:,17)),cell2mat(PMgt20(:,18)),'r.','markersize',13)
line([0 max(cell2mat(data(cell2mat(data(:,5))==20,17)))],[20 20],'color','k','linewidth',1,'linestyle','--')
title([char(cruise) '  >20um Chl - percent range']); xlabel('Chl (mg m^{-3})','fontweight','bold'); ylabel('Percent Range (%)','fontweight','bold');


figure('position',[23 57 1025 784])
subplot(221) %WSW whole seawater
plot(cell2mat(AMwsw(:,6)),cell2mat(AMwsw(:,7)),'b.','markersize',13)
hold on
plot(cell2mat(PMwsw(:,6)),cell2mat(PMwsw(:,7)),'r.','markersize',13)
line([0 20],[0 20],'color','k','linewidth',1,'linestyle','--')
axis([0 WSWmax 0 WSWmax]); axis square
grid on
title([char(cruise) ' - WSW Chl (mg m^{-3})'])
xlabel('Rep a','fontweight','bold'); ylabel('Rep b','fontweight','bold');
subplot(222) %less than 10um
plot(cell2mat(AMlt10(:,6)),cell2mat(AMlt10(:,7)),'b.','markersize',13)
hold on
plot(cell2mat(PMlt10(:,6)),cell2mat(PMlt10(:,7)),'r.','markersize',13)
line([0 20],[0 20],'color','k','linewidth',1,'linestyle','--')
axis([0 LT10max 0 LT10max]); axis square
grid on
legend('AM watch','PM watch')
title([char(cruise) ' - <10um Chl (mg m^{-3})'])
xlabel('Rep a','fontweight','bold'); ylabel('Rep b','fontweight','bold');
subplot(223) %greater than 5um
plot(cell2mat(AMgt5(:,6)),cell2mat(AMgt5(:,7)),'b.','markersize',13)
hold on
plot(cell2mat(PMgt5(:,6)),cell2mat(PMgt5(:,7)),'r.','markersize',13)
line([0 20],[0 20],'color','k','linewidth',1,'linestyle','--')
axis([0 GT5max 0 GT5max]); axis square
grid on
title([char(cruise) ' - >5um Chl (mg m^{-3})'])
xlabel('Rep a','fontweight','bold'); ylabel('Rep b','fontweight','bold');
subplot(224) %greater than 20um
plot(cell2mat(AMgt20(:,6)),cell2mat(AMgt20(:,7)),'b.','markersize',13)
hold on
plot(cell2mat(PMgt20(:,6)),cell2mat(PMgt20(:,7)),'r.','markersize',13)
line([0 20],[0 20],'color','k','linewidth',1,'linestyle','--')
axis([0 GT20max 0 GT20max]); axis square
grid on
title([char(cruise) ' - >20um Chl (mg m^{-3})'])
xlabel('Rep a','fontweight','bold'); ylabel('Rep b','fontweight','bold');
%}

unqcastAMgt20 = unique(cell2mat(AMgt20(:,2)));
unqcastAMgt5 = unique(cell2mat(AMgt5(:,2)));
unqcastPMgt20 = unique(cell2mat(PMgt20(:,2)));
unqcastPMgt5 = unique(cell2mat(PMgt5(:,2)));
figure
hold on
xlabel('>20um Chl ind samples','fontweight','bold'); ylabel('Avg WSW Chl','fontweight','bold'); title('>20um chl vs WSW chl: RED = AM, BLUE = PM');
for count=1:length(unqcastAMgt20)
    toplot = AMgt20(ismember(cell2mat(AMgt20(:,2)),unqcastAMgt20(count)),:);
    plot(cell2mat(toplot(:,6:7)),cell2mat(AMwsw(ismember(cell2mat(AMwsw(:,3)),cell2mat(toplot(:,3)))&ismember(cell2mat(AMwsw(:,2)),unqcastAMgt20(count)),17)),'b.','markersize',10)
end
for count=1:length(unqcastPMgt20)
    toplot = PMgt20(ismember(cell2mat(PMgt20(:,2)),unqcastPMgt20(count)),:);
    plot(cell2mat(toplot(:,6:7)),cell2mat(PMwsw(ismember(cell2mat(PMwsw(:,3)),cell2mat(toplot(:,3)))&ismember(cell2mat(PMwsw(:,2)),unqcastPMgt20(count)),17)),'r.','markersize',10)
end
grid on; axis square;

figure
hold on
xlabel('>5um Chl ind samples','fontweight','bold'); ylabel('Avg WSW Chl','fontweight','bold'); title('>5um chl vs WSW chl: RED = AM, BLUE = PM');
for count=1:length(unqcastAMgt5)
    toplot = AMgt5(ismember(cell2mat(AMgt5(:,2)),unqcastAMgt5(count)),:);
    plot(cell2mat(toplot(:,6:7)),cell2mat(AMwsw(ismember(cell2mat(AMwsw(:,3)),cell2mat(toplot(:,3)))&ismember(cell2mat(AMwsw(:,2)),unqcastAMgt5(count)),17)),'b.','markersize',10)
end
for count=1:length(unqcastPMgt5)
    toplot = PMgt5(ismember(cell2mat(PMgt5(:,2)),unqcastPMgt5(count)),:);
    plot(cell2mat(toplot(:,6:7)),cell2mat(PMwsw(ismember(cell2mat(PMwsw(:,3)),cell2mat(toplot(:,3)))&ismember(cell2mat(PMwsw(:,2)),unqcastPMgt5(count)),17)),'r.','markersize',10)
end
grid on; axis square; 
    
    