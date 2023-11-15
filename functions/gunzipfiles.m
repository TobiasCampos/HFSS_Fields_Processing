function gunzipfiles()
[files,path] = uigetfile('*.nii.gz','Select files','H:\ExportData\Fields','MultiSelect','on');
files = fullfile(path,files);

for i = 1:length(files)
    gunzip(files{i});
end

end