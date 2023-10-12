function GenerateSphericalPhantom(filename,R,C)

filename = strcat(filename,'.txt');

if nargin == 2
    C = [0 ,0 ,0];
end

[px,py,pz] = meshgrid(1:2*R, 1:2*R, 1:2*R);
c = C+R;

A = zeros(2*R,2*R,2*R);
A((px-c(1)).^2 + (py-c(2)).^2 + (pz-c(3)).^2 <= R^2) = 1;

[x, y, z] = ind2sub(size(A), find(A));
xyz_Data=[x, y, z]-R;

writematrix(xyz_Data./1000,filename,'delimiter',' ')

file = dir(filename);
file = fullfile(file.folder,file.name);
[tempDir, tempFile] = fileparts(file); 
copyfile(file, fullfile(tempDir, [tempFile, '.pts']))
delete(file)  

end

