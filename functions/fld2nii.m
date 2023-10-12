function varargout = fld2nii(file)
%FLD2NII converts .fld field data from HFSS to .nii.gz files
% output nifti format:  dim4: 
%                       1: real x    2: imaginary x
%                       3: real y    4: imaginary y
%                       5: real z    6: imaginary z
%
% output varargout:     dim4: 
%                       1: complex x
%                       2: complex y
%                       3: complex z

[~,name,~] = fileparts(file);

Import = importdata(file);

field = Import.data(:,4:end);

coordinates = Import.data(:,1:3).*1000; %m to mm

fields = zeros(floor((max(coordinates(:,1)) - min(coordinates(:,1))))+1, ...
               floor((max(coordinates(:,2)) - min(coordinates(:,2))))+1, ...
               floor((max(coordinates(:,3)) - min(coordinates(:,3))))+1,3);

CScorrection = [min(coordinates(:,1)),min(coordinates(:,2)),min(coordinates(:,3))];

idx = int32((coordinates - CScorrection)+1);

for i = 1:length(idx)
    fields(idx(i,1),idx(i,2),idx(i,3),1) = field(i,1);
    fields(idx(i,1),idx(i,2),idx(i,3),2) = field(i,2);
    fields(idx(i,1),idx(i,2),idx(i,3),3) = field(i,3);
    fields(idx(i,1),idx(i,2),idx(i,3),4) = field(i,4);
    fields(idx(i,1),idx(i,2),idx(i,3),5) = field(i,5);
    fields(idx(i,1),idx(i,2),idx(i,3),6) = field(i,6);
end

niftiwrite(fields,strcat(name,'.nii'));

if nargout == 1
    varargout{1} = complex(fields(:,:,:,[1,3,5]),fields(:,:,:,[2,4,6]));
end

gzip(strcat(name,'.nii'))
delete(strcat(name,'.nii'))
fclose all;
%delete(file)
end