function gunzipfiles(varargin)

if nargin == 0
    [files,path] = uigetfile('*.nii.gz','Select files','H:\ExportData\Fields','MultiSelect','on');
    filelist = fullfile(path,files);
    rootdir = path(1:end-1);
else
    rootdir = varargin{1};
    files = dir(fullfile(rootdir, '**\*.nii.gz'));
    filelist = cell(1,length(files));
    for i = 1:length(files)
        filelist{i} =  fullfile(files(i).folder,files(i).name);
    end
end

fprintf('Unziping %g Files to .nii\n',length(filelist));
unzipfolder = strcat(rootdir,'\','niifiles');

if not(isfolder(unzipfolder))
    mkdir(unzipfolder)
end

for i = 1:length(filelist)
    niifile = gunzip(filelist{i});
    movefile(niifile{1},unzipfolder);
end

end
% rootdir = 'H:\ExportData\microstrip_comparison';
% filelist = dir(fullfile(rootdir, '**\*.nii.gz'));
% fprintf('Converting %g Files to .nii\n',length(filelist));
% for i = 1:length(filelist)
%     file =  fullfile(filelist(i).folder,filelist(i).name);
%     gunzip(file)
% end