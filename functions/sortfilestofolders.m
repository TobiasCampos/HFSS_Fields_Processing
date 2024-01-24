function sortfilestofolders(rootdir,delimiter)
% SORTFILESTOFOLDERS will sort the file based on the filename and the delimiter
% Example: ProjectName_Subfolder_File.ext spacer = '_'
% Folders created:
%       ProjectName
%           Subfolder
%
% If the identifier name is shared they go to the same folder.

files = dir(fullfile(rootdir, '**\*.nii'));
parentfolder = rootdir;
for i = 1:length(files)
    filename = files(i).name;
    idx = strfind(filename,delimiter);

    a = 1;
    for j = 1:length(idx)+1
        if j == length(idx)+1
            folder = filename(a:strfind(filename,'.')-1);
            parentfolder = strcat(parentfolder,'\',folder);
            if not(isfolder(parentfolder))
                mkdir(parentfolder)
            end
            break;
        else
            folder = filename(a:idx(j)-1);
        end
        a = idx(j)+1;
        parentfolder = strcat(parentfolder,'\',folder);
        if not(isfolder(parentfolder))
            mkdir(parentfolder)
        end
    end
    parentfolder = rootdir;
end
end

% files = dir;
% folderNames = {files([files.isdir]).name};
% folderNames = folderNames(~ismember(folderNames ,{'.','..'}));


% rootdir = 'H:\ExportData\alldata(tests)\FIELDS';
% delimiter = '_';
% 
% files = dir(fullfile(rootdir, '**\*.nii')); % '*.nii' to not go into subfolders
% 
% for i = 1:length(files)
%     filename = files(i).name;
%     idx = strfind(filename,delimiter);
% 
%     folder = filename(1:idx-1);
%     if not(isfolder(strcat(rootdir,'\',folder)))
%         mkdir(strcat(rootdir,'\',folder))
%     end
%     file =  fullfile(files(i).folder,files(i).name);
%     movefile(file,strcat(rootdir,'\',folder));
% end