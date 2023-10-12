function Save_HFSSField_Data (SaveName)
%% Get User Input =========================================================
prompt = {'Load .fld files from:','Save .nii to:','Load File:'};
dlgtitle = 'Input: HFSSFields_To_B1Plus';
dims = [1 70];
definput = {'C:\Users\tobia\OneDrive - University of Pittsburgh\{PITT}\[Research]\MATLAB\HFSS Fields Output\Raw Fields Data HFSS', ...
            'C:\Users\tobia\OneDrive - University of Pittsburgh\{PITT}\[Research]\MATLAB\HFSS Fields Output\nii Fields', 'all'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

if numel(answer) > 0
    RAW_Files_Directory = answer{1};
    Processed_Files_Directory = answer{2};
    File = answer{3};
else
    warning('Exit Program')
    return
end

%% Rename File Extension to .txt ==========================================
Modify_File_Type(RAW_Files_Directory,'fld','txt')

%% Read All Files From Directory ==========================================
if File == "all"
    fileList = natsortfiles(dir([RAW_Files_Directory, '\*.txt']));
else
    fileList = dir([RAW_Files_Directory, '\',File,'.txt']);
end

fprintf('Converting %g files to B1Plus\n',numel(fileList))

GPU = gpuDevice;
reset(GPU);

parfor i = 1:numel(fileList)

    Output = Read_HFSS_Fields(fileList(i).folder,fileList(i).name);

    Output.Bplus = (Output.x - (1i * Output.y))/sqrt(2);
    Output.BplusMag = abs(Output.Bplus) .* 1E6; % T uo uT
    Fields(i) = Output;
end

fprintf('Saving Data As: %s\n',SaveName);
save(strcat(Processed_Files_Directory,'\',SaveName,'.mat'),"Fields",'-v7.3');

fprintf('Operation Completed');
end