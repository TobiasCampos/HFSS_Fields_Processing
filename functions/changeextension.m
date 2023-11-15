function changeextension(file,extension)

[dir, name] = fileparts(file); 
copyfile(file, fullfile(dir, [name, extension]));
delete(file)  

end