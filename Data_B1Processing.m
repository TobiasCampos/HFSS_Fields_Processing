clear; clc; close all;
addpath functions\

%analysis_dir = uigetdir('H:\ExportData', 'Select a folder');
analysis_dir = 'H:\ExportData\Analysis_Phantom\uSTTT_111_phantom-B1plusMag-top';

files = natsortfiles(dir(fullfile(analysis_dir, '\*.nii')));

data = cell(length(files),4);
for i = 1:length(files)
    substrate = files(i).name;
    idx = strfind(substrate,'-');

    data{i,1} = substrate(idx(1)+1:idx(3)-1);
    data{i,2} = niftiread(strcat(files(i).folder,'\',files(i).name));
    data{i,3} = mean(data{i,2},'all');
    data{i,4} = max(data{i,2},[],'all');
end

Name = strings(length(data),1);
Mean = zeros(length(data),1);
Maximum = zeros(length(data),1);
Permittivity = zeros(length(data),1);

er = repelem([2.53 3.27 4.5 6 9.2 9.8 12.85],3);
for i = 1:length(data)
    Name(i) = data{i,1};
    Mean(i) = data{i,3};
    Maximum(i) = data{i,4};
    Permittivity(i) = er(i);
end

DataTable = table(Name,Permittivity,Mean,Maximum);

idx5 = find(~cellfun(@isempty,strfind(DataTable.Name,'5.08')));
Data5_08 = DataTable(idx5,:);

idx6 = find(~cellfun(@isempty,strfind(DataTable.Name,'6.35')));
Data6_35 = DataTable(idx6,:);

idx12 = find(~cellfun(@isempty,strfind(DataTable.Name,'12.7')));
Data12_7 = DataTable(idx12,:);

fig = figure;
hold on
plot(Data12_7.Permittivity,Data12_7.Mean,'--.','color',adjust_color([0 1 0]),'LineWidth',1,'MarkerSize',20)
plot(Data6_35.Permittivity,Data6_35.Mean,'--.','color',adjust_color([0 0 1]),'LineWidth',1,'MarkerSize',20)
plot(Data5_08.Permittivity,Data5_08.Mean,'--.','color',adjust_color([1 0 0]),'LineWidth',1,'MarkerSize',20)
hold off

title('Phantom: B1+top vs Substrate Permittivity')
xlabel('Relative Permittivity')
ylabel('Mean B1+ (uT)')
ylim([0.038 0.075])
legend('12.7mm','6.35mm','5.08mm')
set(gca, 'Color','#212121') %'#292929'
set (gca, 'FontWeight', 'bold');
grid on
grid minor
% path = matlab.desktop.editor.getActiveFilename;
% [dir,~,~] = fileparts(path);
% cd(dir)