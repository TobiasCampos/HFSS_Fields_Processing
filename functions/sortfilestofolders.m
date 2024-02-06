function sortfilestofolders(rootdir,delimiter,n)
% SORTFILESTOFOLDERS will sort the file based on the filename and the delimiter
% Example: ProjectName_Subfolder_File.ext spacer = '_'
% Folders created:
%       ProjectName
%           Subfolder
%
% If the identifier name is shared they go to the same folder.
fprintf('Sorting Files\n');

niifiles = dir(fullfile(rootdir,'**\*.nii')); % '*.nii' to not go into subfolders

niidir = strcat(rootdir,'\AnalysisFields');
for i = 1:length(niifiles)
    filename = niifiles(i).name;
    idx = strfind(filename,delimiter);

    folder = filename(1:idx(n)-1);
    if not(isfolder(strcat(niidir,'\',folder)))
        mkdir(strcat(niidir,'\',folder))
    end
    niifile =  fullfile(niifiles(i).folder,niifiles(i).name);
    movefile(niifile,strcat(niidir,'\',folder));
end

csvfiles = dir(fullfile(rootdir,'**\*.csv')); % '*.nii' to not go into subfolders

csvdir = strcat(rootdir,'\_RAW');
for i = 1:length(csvfiles)
    filename = csvfiles(i).name;
    idx = strfind(filename,delimiter);

    folder = filename(1:idx(n)-1);
    if not(isfolder(strcat(csvdir,'\',folder)))
        mkdir(strcat(csvdir,'\',folder))
    end
    csvfile =  fullfile(csvfiles(i).folder,csvfiles(i).name);
    copyfile(csvfile,strcat(niidir,'\',folder));
    movefile(csvfile,strcat(csvdir,'\',folder));
end

gzfiles = dir(fullfile(rootdir,'**\*.nii.gz')); % '*.nii' to not go into subfolders

gzdir = strcat(rootdir,'\_RAW');
for i = 1:length(gzfiles)
    filename = gzfiles(i).name;
    idx = strfind(filename,delimiter);

    folder = filename(1:idx(n)-1);
    if not(isfolder(strcat(gzdir,'\',folder)))
        mkdir(strcat(gzdir,'\',folder))
    end
    gzfile =  fullfile(gzfiles(i).folder,gzfiles(i).name);
    movefile(gzfile,strcat(gzdir,'\',folder));
end

end


% 
% files = dir(fullfile(rootdir,'**\*.nii')); % '*.nii' to not go into subfolders
% 
% niidir = strcat(rootdir,'\niifiles');
% for i = 1:length(files)
%     filename = files(i).name;
%     idx = strfind(filename,delimiter);
% 
%     folder = filename(1:idx(n)-1);
%     if not(isfolder(strcat(rootdir,'\',folder)))
%         mkdir(strcat(rootdir,'\',folder))
%     end
%     file =  fullfile(files(i).folder,files(i).name);
%     movefile(file,strcat(rootdir,'\',folder));
% end
% 
% end



% files = dir;
% folderNames = {files([files.isdir]).name};
% folderNames = folderNames(~ismember(folderNames ,{'.','..'}));


% files = dir(fullfile(rootdir, '**\*.nii'));
% parentfolder = rootdir;
% for i = 1:length(files)
%     filename = files(i).name;
%     idx = strfind(filename,delimiter);
% 
%     a = 1;
%     for j = 1:length(idx)+1
%         if j == length(idx)+1
%             folder = filename(a:strfind(filename,'.')-1);
%             parentfolder = strcat(parentfolder,'\',folder);
%             if not(isfolder(parentfolder))
%                 mkdir(parentfolder)
%             end
%             break;
%         else
%             folder = filename(a:idx(j)-1);
%         end
%         a = idx(j)+1;
%         parentfolder = strcat(parentfolder,'\',folder);
%         if not(isfolder(parentfolder))
%             mkdir(parentfolder)
%         end
%     end
%     parentfolder = rootdir;
% end