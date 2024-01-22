clear; clc; close all;
cd('C:\Users\tobia\OneDrive - University of Pittsburgh\{PITT}\[Research]\Git Workspace\HFSS_Fields_Processing')
addpath functions\

analysis_dir = uigetdir('H:\ExportData', 'Select a folder');
%analysis_dir = 'H:\ExportData\Ground_Test\Fields';

files = natsortfiles(dir(fullfile(analysis_dir, '\*.nii')));

data = cell(length(files),4);
for i = 1:length(files)
    substrate = files(i).name;
    idx = strfind(substrate,' ');

    data{i,1} = substrate(1:idx(1)-3);
    data{i,2} = niftiread(strcat(files(i).folder,'\',files(i).name));
    % data{i,3} = mean(data{i,2},'all');
    % data{i,4} = max(data{i,2},[],'all');
end

Name = strings(size(data,1),1);
Mean = zeros(size(data,1),1);
Maximum = zeros(size(data,1),1);
Permittivity = zeros(size(data,1),1);

er = repelem([2.53 3.27 4.5 6 9.2 9.8 12.85],3);
for i = 1:size(data,1)
    Name(i) = data{i,1};
    Mean(i) = mean(nonzeros(data{i,2}),'all');
    Maximum(i) = max(data{i,2},[],'all');
    Permittivity(i) = 2.53;%er(i);
end

DataTable = table(Name,Permittivity,Mean,Maximum);

% idx5 = find(~cellfun(@isempty,strfind(DataTable.Name,'5.08')));
% Data5_08 = DataTable(idx5,:);
% 
% idx6 = find(~cellfun(@isempty,strfind(DataTable.Name,'6.35')));
% Data6_35 = DataTable(idx6,:);
% 
% idx12 = find(~cellfun(@isempty,strfind(DataTable.Name,'12.7')));
% Data12_7 = DataTable(idx12,:);

% for i = 1:size(data,1)
%     a = reshape (data{i,2},[numel(data{i,2}),1]);
%     a(a==0) = [];
%     figure
%     histogram(nonzeros(a),400,'EdgeColor','none','Normalization','probability');
%     xline(mean(nonzeros(data{i,2}),'all'),'Color',adjust_color([0 0 0]),'LineWidth',1.5)
%     title(data{i,1})
%     set(gca, 'Color','#212121') %'#292929'
% end

% x=1;
% a = reshape (data{x,2},[numel(data{x,2}),1]);
% a(a==0) = [];
% edges = linspace(0,1,400);
% [N1,edges1] = histcounts(a,edges);
% 
% y=8;
% a = reshape (data{y,2},[numel(data{y,2}),1]);
% a(a==0) = [];
% edges = linspace(0,1,400);
% [N2,edges2] = histcounts(a,edges);
% 
% b = bar(edges(1:end-1),(N1-N2),'BarWidth',1,'FaceColor','flat');
% title(strrep(strcat(data{x,1}, '/', data{y,1}),'_',' '))
% set(gcf, 'Color','#212121');    % Plot Color
% set(gca, 'Color','#212121');    % Axis Color
% 
% cm = turbo(size(b.CData,1));
% for c = 1:size(b.CData,1)
%     b.CData(c,:) = cm(c,:);
% end
% 
for i = 1:size(data,1)
    histcm(data{i,2},linspace(0,1,400))
    title(strrep(data{i,1},'_',' '))
    xlabel('Field Intensity (uT)')
    ylabel('Voxel Count')
end

%%
fig = figure;
hold on
plot(str2double(DataTable.Name),DataTable.Mean,'--.','color',adjust_color([0 1 0]),'LineWidth',1,'MarkerSize',15) %%
% plot(Data12_7.Permittivity,Data12_7.Mean,'--.','color',adjust_color([0 1 0]),'LineWidth',1,'MarkerSize',20)
% plot(Data6_35.Permittivity,Data6_35.Mean,'--.','color',adjust_color([0 0 1]),'LineWidth',1,'MarkerSize',20)
% plot(Data5_08.Permittivity,Data5_08.Mean,'--.','color',adjust_color([1 0 0]),'LineWidth',1,'MarkerSize',20)
hold off

title('Phantom: MeanB1+ vs Source Location')
xlabel('Source Location (mm)')
ylabel('Mean B1+ (uT)')
%ylim([0.038 0.075])
%xlim(([1 20]))
set(gca, 'Color','#212121') %'#292929'
set (gca, 'FontWeight', 'bold');
grid on
grid minor
% path = matlab.desktop.editor.getActiveFilename;
% [dir,~,~] = fileparts(path);
% cd(dir)

%%%%
figure;
hold on
plot(str2double(DataTable.Name),DataTable.Maximum,'--.','color',adjust_color([1 0 0]),'LineWidth',1,'MarkerSize',15) %%
hold off

title('Phantom: MaxB1+ vs Source Location')
xlabel('Source Location (mm)')
ylabel('Max B1+ (uT)')
%xlim(([1 20]))
set(gca, 'Color','#212121') %'#292929'
set (gca, 'FontWeight', 'bold');
grid on
grid minor