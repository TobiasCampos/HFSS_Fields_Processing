function fields = makefields(rootdir,match)
%make a 4d fields matrix, dim4 determines the channel

filelist = dir(fullfile(rootdir, strcat('**\*',match,'.nii')));
%filelist = dir(fullfile(rootdir, '**\*B-Field.nii'));
%fields = zeros(1,1,1,1,length(filelist)); %not work
for i = 1:length(filelist)
    file =  fullfile(filelist(i).folder,filelist(i).name);
    field = niftiread(file);
    fields(:,:,:,:,i) = field;
end

end