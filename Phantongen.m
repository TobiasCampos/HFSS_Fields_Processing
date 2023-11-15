clear; close all; clc;
% Creates phantom from local SAR output.

[file,path] = uigetfile('*.fld','Select files','H:\ExportData\Fields','MultiSelect','on');
file = fullfile(path,file);

Import = importdata(file);

field = Import.data(:,4);

coordinates = Import.data(:,1:3).*1000; %m to mm

fields = zeros(floor((max(coordinates(:,1)) - min(coordinates(:,1))))+1, ...
               floor((max(coordinates(:,2)) - min(coordinates(:,2))))+1, ...
               floor((max(coordinates(:,3)) - min(coordinates(:,3))))+1,1);

CScorrection = [min(coordinates(:,1)),min(coordinates(:,2)),min(coordinates(:,3))];

idx = int32((coordinates - CScorrection)+1);

for i = 1:length(idx)
    fields(idx(i,1),idx(i,2),idx(i,3)) = field(i);
end

fields(fields ~= 0) = 1;

[x, y, z] = ind2sub(size(fields), find(fields));
xyz_Data=[x, y, z]+CScorrection;
plot3(xyz_Data(:,1), xyz_Data(:,2), xyz_Data(:,3), '.');

writematrix(xyz_Data./1000,'Headphantom.txt','delimiter',' ')
changeextension('Headphantom.txt','.pts')
%niftiwrite(fields,'test.nii');