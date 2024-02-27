clear; clc; close all;

addpath functions\

rootdir = input('>>> Enter fields directory:',"s");

if isempty(rootdir)
    rootdir = uigetdir('H:\ExportData', 'Select a folder');
end

A = [0 0 0 0];
phi = [0 0 0 0];

sig = niftiread("H:\PersonalLib\Geometry Properties\SphereProperties\sig(Sphere).nii");
mu = niftiread("H:\PersonalLib\Geometry Properties\SphereProperties\mu(Sphere).nii");

allfiles = dir(rootdir);
folderNames = {allfiles([allfiles.isdir]).name};
folderNames = folderNames(~ismember(folderNames ,{'.','..'}));

if not(isfolder(strcat(rootdir,'\ProcessedFields')))
   mkdir((strcat(rootdir,'\ProcessedFields')))
end

for i = 1:length(folderNames)
    fprintf('%g Files Remaining\n',(length(folderNames)-(i-1)));
    %natsortfiles?
    folder = strcat(rootdir,'\',folderNames{i});
    fields = makefields(folder,'H-Field');
    for p = 1:4
        A(p) = 1;
        % B1-Field Analysis
        field = combinefields(fields,A,phi);
        field = mu.*field; % H -> B

        B1plus = (field(:,:,:,1) - (1i * field(:,:,:,2)))/sqrt(2);
        B1p(:,:,:,1) = abs(B1plus) .* 1E6;  % Complex magnitude T => uT
        B1p(:,:,:,2) = angle(B1plus);       % Phase

        name = sprintf('%s_B1+-Field_Port-%g',folderNames{i},p);
        niftiwrite(B1p(:,:,:,1),strcat(rootdir,'\ProcessedFields\',name,'.nii'));
        A = [0 0 0 0];
    end
end
% Organize Files
fclose all;

rootdir = strcat(rootdir,'\ProcessedFields');
delimiter = '_';

files = dir(fullfile(rootdir, '*.nii'));

for i = 1:length(files)
    filename = files(i).name;
    idx = strfind(filename,delimiter);

    folder = filename(1:idx(1)-1);
    if not(isfolder(strcat(rootdir,'\',folder)))
        mkdir(strcat(rootdir,'\',folder))
    end
    file =  fullfile(files(i).folder,files(i).name);
    movefile(file,strcat(rootdir,'\',folder));
end

% Plot Results
filelist = dir(fullfile(rootdir, '**\*.nii'));

Port1    = cell(round(length(filelist)/4),2);
Port2    = cell(round(length(filelist)/4),2);
Port3    = cell(round(length(filelist)/4),2);
Port4    = cell(round(length(filelist)/4),2);
a = 1; b = 1; c = 1; d = 1;
for i = 1:length(filelist)
    file =  fullfile(filelist(i).folder,filelist(i).name);
    name = filelist(i).name;
    idx = strfind(name,'_');

    if     any(contains(name,'_Port-1'))
        Port1{a,1} = name(1:idx(2)-1);
        Port1{a,2} = niftiread(strcat(filelist(i).folder,'\',filelist(i).name));
        a = a+1;
    elseif any(contains(name,'_Port-2'))
        Port2{b,1} = name(1:idx(2)-1);
        Port2{b,2} = niftiread(strcat(filelist(i).folder,'\',filelist(i).name));
        b = b+1;
    elseif any(contains(name,'_Port-3'))
        Port3{c,1} = name(1:idx(2)-1);
        Port3{c,2} = niftiread(strcat(filelist(i).folder,'\',filelist(i).name));
        c = c+1;
    elseif any(contains(name,'_Port-4'))
        Port4{d,1} = name(1:idx(2)-1);
        Port4{d,2} = niftiread(strcat(filelist(i).folder,'\',filelist(i).name));
        d = d+1;
    end
end

data{1} = Port1(1:a-1,:);
data{2} = Port2(1:b-1,:);
data{3} = Port3(1:c-1,:);
data{4} = Port4(1:c-1,:);
Titles = ["Port1","Port2","Port3","Port4"];

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
% for c = 1:length(data)
%     n = cell(size(data{c},1),1);
%     m = zeros(size(data{c},1),1);
%     o = m;
%     for i = 1:size(data{c},1)
%         n{i} = regexp(data{c}{i,1},'\d+\.?\d*','Match');
%         n{i} = n{i}(1);
%         m(i) = mean(nonzeros(data{c}{i,2}),"all");
%         o(i) = max(data{c}{i,2},[],"all");
%     end
%     b = cellfun(@(x)str2double(x), n);
% 
%     figure
%     hold on
%     grid on
%     grid minor
%     title(Titles(c))
%     set(gca, 'Color','#212121') %'#292929'
%     plot(b,m,'g--.','MarkerSize',15)
%     legend('Mean');
%     xlim([(min(b) -1) (max(b) +1)])
%     hold off
% 
%     figure
%     hold on
%     grid on
%     grid minor
%     title(Titles(c))
%     set(gca, 'Color','#212121') %'#292929'
%     plot(b,o,'r--.','MarkerSize',15)
%     legend('Max');
%     xlim([(min(b) -1) (max(b) +1)])
%     hold off
% end
% Open NifTi
clearvars -except rootdir
filelist = dir(fullfile(rootdir, '**\*.nii'));

Port1    = cell(round(length(filelist)/4),1);
Port2    = cell(round(length(filelist)/4),1);
Port3    = cell(round(length(filelist)/4),1);
Port4    = cell(round(length(filelist)/4),1);
a = 1; b = 1; c = 1; d = 1;
for i = 1:length(filelist)
    file =  fullfile(filelist(i).folder,filelist(i).name);

    if     any(contains(filelist(i).name,'_Port-1'))
        Port1{a,1} = file;
        a = a+1;
    elseif any(contains(filelist(i).name,'_Port-2'))
        Port2{b,1} = file;
        b = b+1;
    elseif any(contains(filelist(i).name,'_Port-3'))
        Port3{c,1} = file;
        c = c+1;
    elseif any(contains(filelist(i).name,'_Port-4'))
        Port4{d,1} = file;
        d = d+1;
    end
end

data{1} = Port1(1:a-1,:);
data{2} = Port2(1:b-1,:);
data{3} = Port3(1:c-1,:);
data{4} = Port4(1:d-1,:);

for c = 1:length(data)
    concatenated_files = strjoin(data{c}(2:end), ' ');
    files = ['"' concatenated_files '"'];
    [~] = system(['start "" "C:\Program Files\ITK-SNAP 4.0\bin\ITK-SNAP.exe" -g "' data{c}{1} '" -o "' files]);
end
