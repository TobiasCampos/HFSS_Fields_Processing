function  Modify_File_Type(directory,ext_old,ext_new)

files = dir([directory, '\*.',ext_old]); %**\*.fld

for id = 1:length(files)
    [~,f,~] = fileparts(files(id).name);
    movefile(strcat(directory,'\',files(id).name), strcat(directory,'\',f,'.',ext_new));
end

if id >= 1
    fprintf('%g file extensions renamed\n',id)
else
    disp('No file extension renamed')
end

end

