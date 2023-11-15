clear; close all; clc;
addpath("functions\");
parallel = 0;
[files,path] = uigetfile({'*.nii.gz';'*.nii'},'Select files','H:\ExportData\Fields','MultiSelect','on');
files = fullfile(path,files);


if isequal(files,0) || isequal(files(2),'\')
    disp('User Cancelled');
    return
end

if ischar(files)
    fprintf('1 File selected\n');
    B1plus(files);
else
    fprintf('%g Files selected\n',length(files));
    if parallel
        parfor i = 1:length(files)
            B1plus(files{i},'B0','+z');
        end
    else
        for i = 1:length(files)
            B1plus(files{i},'B0','+z');
        end
    end
end

% fclose all;
% if any(strcmp(varargin, 'delete'))
%     for i = 1:length(files)
%         delete(files{i});
%     end
% end

%if any(strcmp(varargin, 'B1plus'))
%any(contains('H:\ExportData\Fields\uSTTT_111-TMM3_Phantom\TMM3_5.08_B-field.nii', 'B-field'))
%end %Automatically convert the files that cointain B-field to B1Plus.