clear; clc; close all;

clear; close all; clc;
addpath("functions\");

[files,path] = uigetfile({'*.nii';'*.nii.gz'},'Select files','H:\ExportData\Fields','MultiSelect','on');
files = fullfile(path,files);
[dir,name,ext] = fileparts(files);

data = cell(length(files),2);
for i = 1:length(files)
    data{i,1} = name{i};
    data{i,2} = niftiread(files{i});
end
data{1,1}
m1 = mean(data{1,2},'all')

data{2,1}
m2 = mean(data{2,2},'all')

data{1,1}
m1 = max(data{1,2},[],'all')

data{2,1}
m2 = max(data{2,2},[],'all')