function varargout = B1plus(file, varargin)
%B1PLUS Calculates B1+ from B<x,y,z> nii.gz file
% Varargin:
%                       'B0','+z' Give the direction of the B0 field
%                       '.gz' compresses the file

[path,name,ext] = fileparts(file);

if ext == ".gz"
    niifile = gunzip(file);
    field = niftiread(niifile{1});
    delete(niifile{1});
elseif ext == ".nii"
    field = niftiread(file);
end

field = complex(field(:,:,:,[1,3,5]),field(:,:,:,[2,4,6]));
if any(strcmp(varargin, 'B0'))
    B0 = varargin{find(strcmp(varargin, 'B0'))+1};
else
    B0 = '+z';
end

switch B0
    case '+z'
        B1plus = (field(:,:,:,1) - (1i * field(:,:,:,2)))/sqrt(2);  %B0 in +z
    case '+x'
        B1plus = (field(:,:,:,2) - (1i * field(:,:,:,3)))/sqrt(2);  %B0 in +x
    otherwise
        error('invalid B0 Direction')
end

B1p(:,:,:,1) = abs(B1plus)   .* 1E6; % T uo uT

if nargout == 1
    B1p(:,:,:,2) = angle(B1plus);%Phase
    varargout{1} = B1p;
end

niftiwrite(B1p,strcat(path,'\',name,'_B1plusMag','.nii'));

if any(strcmp(varargin, '.gz'))
    gzip(strcat(path,'\',name,'_B1plusMag','.nii'));
    delete(strcat(path,'\',name,'_B1plusMag','.nii'));
end

end