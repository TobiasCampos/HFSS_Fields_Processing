function varargout = B1plus(varargin)
%B1PLUS Calculates B1+ from B<x,y,z> nii.gz file
% Varargin:
%                       varargin{1}: fullfile to be converted

if nargin == 0
    [file,path] = uigetfile('*.nii.gz','Select files','H:\ExportData\Fields','MultiSelect','on');
    file = fullfile(path,file);
    [path,name,~] = fileparts(file);
else
    file = varargin{1};
    [path,name,~] = fileparts(file);
end

if isequal(name,0)
    disp('User Cancelled');
    return
end

niifile = gunzip(file);
field = niftiread(niifile{1});
delete(niifile{1});

field = complex(field(:,:,:,[1,3,5]),field(:,:,:,[2,4,6]));

B1plus = (field(:,:,:,1) - (1i * field(:,:,:,2)))/sqrt(2);
B1plusMag = abs(B1plus) .* 1E6; % T uo uT

if nargout == 1
    varargout{1} = B1plusMag;
elseif nargout == 2
    varargout{1} = B1plusMag;
    varargout{2} = B1plus;
end

niftiwrite(B1plusMag,strcat(path,'\',name,'_B1plusMag','.nii'));
gzip(strcat(path,'\',name,'_B1plusMag','.nii'));
delete(strcat(path,'\',name,'_B1plusMag','.nii'));

end