function varargout = fld2nii(file,varargin)
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
%
% Varargin:
%                       'notsave' will not save a .nii.gz
%                       'delete'  will delete the original file

[path,name,~] = fileparts(file);

Import = importdata(file);

field = Import.data(:,4:end);

coordinates = Import.data(:,1:3).*1000; %m to mm

fields = zeros(floor((max(coordinates(:,1)) - min(coordinates(:,1))))+1, ...
               floor((max(coordinates(:,2)) - min(coordinates(:,2))))+1, ...
               floor((max(coordinates(:,3)) - min(coordinates(:,3))))+1,3);

CScorrection = [min(coordinates(:,1)),min(coordinates(:,2)),min(coordinates(:,3))];

idx = int32((coordinates - CScorrection)+1);

columns = size(Import.data,2)-3;
for i = 1:length(idx)
    for c = 1:columns
        fields(idx(i,1),idx(i,2),idx(i,3),c) = field(i,c);
    end
end

if nargout == 1
    varargout{1} = complex(fields(:,:,:,[1,3,5]),fields(:,:,:,[2,4,6]));
end

if any(strcmp(varargin, 'notsave'))
else
    niftiwrite(fields,strcat(path,'\',name,'.nii'));
    gzip(strcat(path,'\',name,'.nii'))
    delete(strcat(path,'\',name,'.nii'))
end

fclose all;
if any(strcmp(varargin, 'delete'))
    delete(file)
end

end