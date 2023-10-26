function convertfiles(varargin)
%CONVERTFILES converts .fld to .nii.gz files
% Varargin:
%                       varargin{1}: directory of files to be converted
%                       'delete'  will delete the original file
%                       'Parallel' will enter a parfor to call fld2nii
%                       'B1plus' converts the files containing 'B-field' to B1plus


if nargin == 0
    [files,path] = uigetfile('*.fld','Select files','H:\ExportData\Fields','MultiSelect','on');
    files = fullfile(path,files);
else
    path = varargin{1};
    filelist = dir(fullfile(path, '\*.fld'));
    files = cell(1,length(filelist));
    for i = 1:length(filelist)
        files{i} =  fullfile(path,filelist(i).name);
    end
end

if isequal(files,0)
    disp('User Cancelled');
    return
end

if ischar(files)
    fprintf('1 File selected\n');
    fld2nii(files);
else
    fprintf('%g Files selected\n',length(files));
    if any(strcmp(varargin, 'parallel'))
        parfor i = 1:length(files)
            fld2nii(files{i});
        end
    else
        for i = 1:length(files)
            fld2nii(files{i});
        end
    end
end

fclose all;
if any(strcmp(varargin, 'delete'))
    for i = 1:length(files)
        delete(files{i});
    end
end

%if any(strcmp(varargin, 'B1plus'))
%any(contains('H:\ExportData\Fields\uSTTT_111-TMM3_Phantom\TMM3_5.08_B-field.nii', 'B-field'))
%end %Automatically convert the files that cointain B-field to B1Plus.

end