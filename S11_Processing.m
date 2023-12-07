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
    data{i,2} = readmatrix(strcat(files(i).folder,'\',files(i).name));
end

Name = strings(length(data),1);
S11db = zeros(length(data),1);
S11 = zeros(length(data),1);
S21 = zeros(length(data),1);

for i = 1:length(data)
    Name(i) = data{i,1};
    [~,closestIndex] = min(abs(data{i,2}(:,1)-297.2));
    S11db(i) = data{i,2}(closestIndex,2);
    S11(i) = 10^(S11db(i)/20);
    S21(i) = 1-S11(i);
end

S11Table = table(Name,S11db,S11,S21);
save("S11Table.mat","S11Table",'-mat')

fig = figure;

plot(str2double(S11Table.Name),S11Table.S11,'--.','color',adjust_color([0 1 0]),'LineWidth',1,'MarkerSize',20)

title('S(1,1) vs Substrate Permittivity')
xlabel('Trace Spacing')
ylabel('S(1,1)')
%legend('12.7mm','6.35mm','5.08mm')
set(gca, 'Color','#212121') %'#292929'
set (gca, 'FontWeight', 'bold');
grid on
grid minor