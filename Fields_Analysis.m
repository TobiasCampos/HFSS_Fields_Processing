clear; clc; close all;

addpath functions\

rootdir = input('>>> Enter fields directory:',"s");

if isempty(rootdir)
    rootdir = uigetdir('H:\ExportData', 'Select a folder');
end

filelist = dir(fullfile(rootdir, '**\*.nii'));

B1perW      = cell(round(length(filelist)/3),2);
B1perSAR    = cell(round(length(filelist)/3),2);
SAR         = cell(round(length(filelist)/3),2);
a = 1; b = 1; c = 1;
for i = 1:length(filelist)
    file =  fullfile(filelist(i).folder,filelist(i).name);
    name = filelist(i).name;
    idx = strfind(name,'_');

    if     any(contains(name,'_B1+'))
        B1perW{a,1} = name(1:idx(2)-1);
        B1perW{a,2} = niftiread(strcat(filelist(i).folder,'\',filelist(i).name));
        a = a+1;
    elseif any(contains(name,'_SAReff_'))
        B1perSAR{b,1} = name(1:idx(2)-1);
        B1perSAR{b,2} = niftiread(strcat(filelist(i).folder,'\',filelist(i).name));
        b = b+1;
    elseif any(contains(name,'_SAR_'))
        SAR{c,1} = name(1:idx(2)-1);
        SAR{c,2} = niftiread(strcat(filelist(i).folder,'\',filelist(i).name));
        c = c+1;
    end
end

data{1} = B1perW(1:a-1,:);
data{2} = B1perSAR(1:b-1,:);
data{3} = SAR(1:c-1,:);
Titles = ["B1+/Watt","B1+/SAR","SAR"];

% Plot Histograms
for c = 1:length(data)
    figure
    grid on
    grid minor
    title(Titles(c))
    set(gca, 'Color','#212121') %'#292929'
    hold on
    for i = 1:size(data{c},1)
        a = reshape (data{c}{i,2},[numel(data{c}{i,2}),1]);
        a(a==0) = [];
        histogram(a,1000,'Normalization','count','DisplayStyle','stairs');
    end
    legend(data{c}{:,1})
    hold off
end

% Plot Mean and Max B1
for c = 1:length(data)
    n = cell(size(data{c},1),1);
    m = zeros(size(data{c},1),1);
    o = m;
    for i = 1:size(data{c},1)
        n{i} = regexp(data{c}{i,1},'\d+\.?\d*','Match');
        n{i} = n{i}(1);
        m(i) = mean(nonzeros(data{c}{i,2}),"all");
        o(i) = max(data{c}{i,2},[],"all");
    end
    b = cellfun(@(x)str2double(x), n);

    figure
    hold on
    grid on
    grid minor
    title(Titles(c))
    set(gca, 'Color','#212121') %'#292929'
    plot(b,m,'g--.','MarkerSize',15)
    legend('Mean');
    xlim([(min(b) -1) (max(b) +1)])
    hold off

    figure
    hold on
    grid on
    grid minor
    title(Titles(c))
    set(gca, 'Color','#212121') %'#292929'
    plot(b,o,'r--.','MarkerSize',15)
    legend('Max');
    xlim([(min(b) -1) (max(b) +1)])
    hold off
end