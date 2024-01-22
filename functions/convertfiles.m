function convertfiles(varargin)
%CONVERTFILES converts .fld to .nii.gz files
% Varargin:
%                       varargin{1}: directory of files to be converted
%                       'delete'  will delete the original file
%                       'parallel' will enter a parfor to call fld2nii
%                       'B1plus' converts the files containing 'B-Field' to B1plus


if nargin == 0 || varargin{1} == "parallel"
    [files,path] = uigetfile('*.fld','Select files','H:\ExportData\Fields','MultiSelect','on');
    files = fullfile(path,files);
else
    rootdir = varargin{1};%'H:\ExportData\microstrip comparison';
    filelist = dir(fullfile(rootdir, '**\*.fld'));  %get list of files and folders in any subfolder
    files = cell(1,length(filelist));
    for i = 1:length(filelist)
        files{i} =  fullfile(filelist(i).folder,filelist(i).name);
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
    l = length(files);
    fprintf('%g Files selected\n',l);
    if any(strcmp(varargin, 'parallel'))
        parfor i = 1:length(files)
            fprintf('%g Files Remaining\n',(l-i));
            fld2nii(files{i});
        end
    else
        for i = 1:length(files)
            fprintf('%g Files Remaining\n',(l-i));
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

if any(strcmp(varargin, 'B1plus'))
    filelist = dir(fullfile(rootdir, '**\*.nii'));
    fprintf('Converting %g Files to B1 Plus\n',length(filelist));
    for i = 1:length(filelist)
        file =  fullfile(filelist(i).folder,filelist(i).name);
        if any(contains(file,'B-Field'))
            B1plus(file)
        end
    end

end
%any(contains('H:\ExportData\Fields\uSTTT_111-TMM3_Phantom\TMM3_5.08_B-field.nii', 'B-Field'))
%end %Automatically convert the files that cointain B-field to B1Plus.

end

%rootdir = 'H:\ExportData\microstrip comparison';
%filelist = dir(fullfile(rootdir, '**\*.fld'));  %get list of files and folders in any subfolder
%filelist = filelist(~[filelist.isdir])  %remove folders from list