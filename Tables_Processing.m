clear; clc; close all;
addpath functions\

analysis_dir = uigetdir('H:\ExportData', 'Select a folder');
%analysis_dir = 'H:\ExportData\Analysis_Phantom\Tables';

files = natsortfiles(dir(fullfile(analysis_dir, '\*.csv')));
warning off

data = cell(length(files),2);
for i = 1:length(files)
    substrate = files(i).name;
    idx = strfind(substrate,'-');

    data{i,1} = substrate(idx(2)+1:idx(2)+2);
    data{i,2} = readtable(strcat(files(i).folder,'\',files(i).name));
end

Name = strings(length(data),1);
RadiatedPower = zeros(length(data),1);
AcceptedPower = zeros(length(data),1);
RadiationEfficiency = zeros(length(data),1);
TotalEfficiency = zeros(length(data),1);
Permittivity = zeros(length(data),1);

er = repelem([2.53 3.27 4.5 6 9.2 9.8 12.85],3);
for i = 1:length(data)
    Name(i) = data{i,1};
    RadiatedPower(i) = data{i,2}.RadiatedPower__;
    AcceptedPower(i) = data{i,2}.AcceptedPower__;
    RadiationEfficiency(i) = data{i,2}.RadiationEfficiency__;
    TotalEfficiency(i) = data{i,2}.TotalEfficiency__;
    Permittivity(i) = er(1);
end

DataTable = table(Name,Permittivity,RadiatedPower,AcceptedPower,RadiationEfficiency,TotalEfficiency);

% idx5 = find(~cellfun(@isempty,strfind(DataTable.Name,'5.08')));
% Data5_08 = DataTable(idx5,:);
% 
% idx6 = find(~cellfun(@isempty,strfind(DataTable.Name,'6.35')));
% Data6_35 = DataTable(idx6,:);
% 
% idx12 = find(~cellfun(@isempty,strfind(DataTable.Name,'12.7')));
% Data12_7 = DataTable(idx12,:);

fig = figure;
hold on
plot(str2double(DataTable.Name),DataTable.TotalEfficiency,'--.','color',adjust_color([0 1 0]),'LineWidth',1,'MarkerSize',20)
%plot(Data12_7.Permittivity,Data12_7.TotalEfficiency,'--.','color',adjust_color([0 1 0]),'LineWidth',1,'MarkerSize',20)
%plot(Data6_35.Permittivity,Data6_35.TotalEfficiency,'--.','color',adjust_color([0 0 1]),'LineWidth',1,'MarkerSize',20)
%plot(Data5_08.Permittivity,Data5_08.TotalEfficiency,'--.','color',adjust_color([1 0 0]),'LineWidth',1,'MarkerSize',20)
hold off

title('Total Efficiency vs Substrate Permittivity')
xlabel('Trace Spacing')
ylabel('TotalEfficiency')
%legend('12.7mm','6.35mm','5.08mm')
set(gca, 'Color','#212121') %'#292929'
set (gca, 'FontWeight', 'bold');
grid on
grid minor
% path = matlab.desktop.editor.getActiveFilename;
% [dir,~,~] = fileparts(path);
% cd(dir)