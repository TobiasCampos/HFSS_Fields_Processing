clear; clc;

[file,path] = uigetfile({'*.fld';'*.nii.gz'},'Select a file','C:\Documents\AppBuildingFiles\','MultiSelect','on');


% FileNames = uigetfile('*.mat','Select the tissue mesh file to open', 'MultiSelect', 'on');
% [FileName, PathName] = uigetfile('*.mat','Select meshes','MultiSelect','on');
% 
% selpath = uigetdir(path,title);
% fileList = natsortfiles(dir([RAW_Files_Directory, '\*.txt'])); % \*.fld
% 
% d = uigetdir(pwd, 'Select a folder');
% files = dir(fullfile(d, '\*.fld'));
% 
% if not(isfolder(yourFolder))
%     mkdir(yourFolder)
% end
% if ~exist(yourFolder, 'dir')
%        mkdir(yourFolder)
% end

%https://uk.mathworks.com/help/matlab/ref/movefile.html