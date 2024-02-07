clear; close all; clc;

addpath functions\

rootdir = input('>>>Enter fields directory:',"s");

if isempty(rootdir)
    rootdir = 'H:\ExportData\[RawData]';
end

convertfiles(rootdir,'parallel','delete');
sortfilestofolders(rootdir,'_',1);

