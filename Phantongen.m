clear; close all; clc;
addpath functions\
% Creates phantom from .fld file where places outlide the region of interest have intensity of 0. Example:SAR output.

[file,path] = uigetfile('*.fld','Select files','H:\ExportData\Fields','MultiSelect','on');
file = fullfile(path,file);
fprintf('Files selected: %s\n',file);

Import = importdata(file);

fprintf('data imported\n');

field = Import.data(:,4);

coordinates = Import.data(:,1:3).*1000; %m to mm

fields = zeros(floor((max(coordinates(:,1)) - min(coordinates(:,1))))+1, ...
               floor((max(coordinates(:,2)) - min(coordinates(:,2))))+1, ...
               floor((max(coordinates(:,3)) - min(coordinates(:,3))))+1,1);

CScorrection = [min(coordinates(:,1)),min(coordinates(:,2)),min(coordinates(:,3))];

idx = int32((coordinates - CScorrection)+1);

fprintf('building matrix\n');

for i = 1:length(idx)
    fields(idx(i,1),idx(i,2),idx(i,3)) = field(i);
end

%remove panel:
fields(1:140,50:190,130:300) = 0;

fields(fields ~= 0) = 1;

fprintf('finalizing\n');

[x, y, z] = ind2sub(size(fields), find(fields));
xyz_Data = [x, y, z]+CScorrection;
xyz_Data = xyz_Data./1000;
%plot3(xyz_Data(:,1), xyz_Data(:,2), xyz_Data(:,3), '.');

fprintf('saving\n');
niftiwrite(fields,'test.nii');

fileID = fopen(strcat(path,'Headphantom.txt'),'w');
fprintf(fileID,'%g %g %g\n',xyz_Data');
fclose(fileID);
% writematrix(xyz_Data./1000,'Headphantom.txt','delimiter',' ')
changeextension(strcat(path,'Headphantom.txt'),'.pts');

fprintf('done\n');