function changeextension(file,extension)

[dir, name] = fileparts(file); 
copyfile(file, fullfile(dir, [name, extension]));
delete(file)  
%movefile may be faster to rename
end