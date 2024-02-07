clear; clc; close all;

addpath functions\

rootdir = input('>>>Enter fields directory:',"s");

if isempty(rootdir)
    rootdir = uigetdir('H:\ExportData', 'Select a folder');
end

A = [0.25 0.25 0.25 0.25];
phi = [0 90 180 270];

sig = niftiread("H:\PersonalLib\Geometry Properties\Phantom material properties\sig(phantom).nii");
mu = niftiread("H:\PersonalLib\Geometry Properties\Phantom material properties\mu(phantom).nii");

allfiles = dir(rootdir);
folderNames = {allfiles([allfiles.isdir]).name};
folderNames = folderNames(~ismember(folderNames ,{'.','..'}));

if not(isfolder(strcat(rootdir,'\ProcessedFields')))
   mkdir((strcat(rootdir,'\ProcessedFields')))
end

for i = 1:length(folderNames)
fprintf('%g Files Remaining\n',(length(folderNames)-i));

%natsortfiles?
folder = strcat(rootdir,'\',folderNames{i});

% B1-Field Analysis
fields = makefields(folder,'H-Field');
field = combinefields(fields,A,phi);
field = mu.*field; % H -> B

B1plus = (field(:,:,:,1) - (1i * field(:,:,:,2)))/sqrt(2);
B1p(:,:,:,1) = abs(B1plus) .* 1E6;  % Complex magnitude T uo uT
B1p(:,:,:,2) = angle(B1plus);       % Phase

meanB1 = mean(nonzeros(B1p(:,:,:,1)),"all");

name = sprintf('%s_B1+-Field_mean-%g',folderNames{i},meanB1);
niftiwrite(B1p(:,:,:,1),strcat(rootdir,'\ProcessedFields\',name,'.nii'));

% E-Field Analysis
fields = makefields(folder,'E-Field');
field = combinefields(fields,A,phi);

E = magphase(field);

meanE = mean(nonzeros(E(:,:,:,1)),"all");

% name = sprintf('%s_combined_E-field_mean-%g',folderNames{i},meanE);
% niftiwrite(E(:,:,:,1),strcat(rootdir,'\ProcessedFields\',name,'.nii'));

% SAR Analysis
SAR = sig.*E(:,:,:,1).^2; % sig*E^2

meanSAR = mean(nonzeros(SAR(:,:,:,1)),"all");

name = sprintf('%s_SAR_mean-%g',folderNames{i},meanSAR);
niftiwrite(SAR(:,:,:,1),strcat(rootdir,'\ProcessedFields\',name,'.nii'));

% SAR Efficiency

SAReff = B1p(:,:,:,1)./sqrt(SAR(:,:,:,1));
SAReff(isnan(SAReff))=0;
SAReff(SAReff == inf)=0;

meanSAReff = mean(nonzeros(SAReff(:,:,:,1)),"all");

name = sprintf('%s_SAReffvoxelwise_mean-%g',folderNames{i},meanSAReff);
niftiwrite(SAReff,strcat(rootdir,'\ProcessedFields\',name,'.nii'));

% B1/sqrt(Average SAR)

mSAReff = B1p(:,:,:,1)./sqrt(meanSAR);

meanmSAReff = mean(nonzeros(mSAReff(:,:,:,1)),"all");

name = sprintf('%s_SAReff_mean-%g',folderNames{i},meanmSAReff);
niftiwrite(mSAReff,strcat(rootdir,'\ProcessedFields\',name,'.nii'));

end
fclose all;

rootdir = strcat(rootdir,'\ProcessedFields');
delimiter = '_';

files = dir(fullfile(rootdir, '*.nii'));

for i = 1:length(files)
    filename = files(i).name;
    idx = strfind(filename,delimiter);

    folder = filename(1:idx(1)-1);
    if not(isfolder(strcat(rootdir,'\',folder)))
        mkdir(strcat(rootdir,'\',folder))
    end
    file =  fullfile(files(i).folder,files(i).name);
    movefile(file,strcat(rootdir,'\',folder));
end
%sig = abs((eps(:,:,:,2).*(2.972e+8*2*pi))./-1i);