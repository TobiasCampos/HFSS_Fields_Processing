clear; close all; clc;

addpath functions\

rootdir = input('enter fields directory',"s");

if isempty(rootdir)
    rootdir = 'H:\ExportData\microstrip_comparison';
end

analysisdir = 'alldata';

analysisdir = strcat(rootdir,'\',analysisdir);

%convertfiles(rootdir,'parallel','B1plus')

mkdir(analysisdir)
mkdir(strcat(analysisdir,'\','E-Field'))
mkdir(strcat(analysisdir,'\','B-Field'))
mkdir(strcat(analysisdir,'\','sigE-Field'))
mkdir(strcat(analysisdir,'\','B1plus'))
mkdir(strcat(analysisdir,'\','RHCP'))
mkdir(strcat(analysisdir,'\','csvfiles'))

filelist = dir(fullfile(rootdir, '**\*.nii')); % move all.nii files to the analysis dir
for i = 1:length(filelist)
    file =  fullfile(filelist(i).folder,filelist(i).name);

    if     any(contains(file,'B-Field'))
        movefile(file,strcat(analysisdir,'\','B-Field'));
    elseif any(contains(file,'sigE-Field'))
        movefile(file,strcat(analysisdir,'\','sigE-Field'));
    elseif any(contains(file,'E-Field'))
        movefile(file,strcat(analysisdir,'\','E-Field'));
    elseif any(contains(file,'B1plus'))
        movefile(file,strcat(analysisdir,'\','B1plus'));
    elseif any(contains(file,'RHCP'))
        movefile(file,strcat(analysisdir,'\','RHCP'));
    end
end


filelist = dir(fullfile(rootdir, '**\*.csv')); % move all.csv files to the analysis dir
for i = 1:length(filelist)
    file =  fullfile(filelist(i).folder,filelist(i).name);
    copyfile(file,strcat(analysisdir,'\','csvfiles'));
end