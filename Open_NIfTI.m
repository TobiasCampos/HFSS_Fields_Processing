clear; clc;

%addpath functions\

rootdir = input('>>> Enter fields directory:',"s");

if isempty(rootdir)
    rootdir = uigetdir('H:\ExportData', 'Select a folder');
end

filelist = dir(fullfile(rootdir, '**\*.nii'));

B1perW      = cell(round(length(filelist)/3),1);
B1perSAR    = cell(round(length(filelist)/3),1);
SAR         = cell(round(length(filelist)/3),1);
a = 1; b = 1; c = 1;
for i = 1:length(filelist)
    file =  fullfile(filelist(i).folder,filelist(i).name);

    if     any(contains(filelist(i).name,'_B1+'))
        B1perW{a,1} = file;
        a = a+1;
    elseif any(contains(filelist(i).name,'_SAReff_'))
        B1perSAR{b,1} = file;

        b = b+1;
    elseif any(contains(filelist(i).name,'_SAR_'))
        SAR{c,1} = file;
        c = c+1;
    end
end

data{1} = B1perW(1:a-1,:);
data{2} = B1perSAR(1:b-1,:);
data{3} = SAR(1:c-1,:);

for c = 1:length(data)
    concatenated_files = strjoin(data{c}(2:end), ' ');
    files = ['"' concatenated_files '"'];
    [~] = system(['start "" "C:\Program Files\ITK-SNAP 4.0\bin\ITK-SNAP.exe" -g "' data{c}{1} '" -o "' files]);
end
