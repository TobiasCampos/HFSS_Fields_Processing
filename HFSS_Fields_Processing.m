clear; clc; close all;

addpath functions\

rootdir = input('enter fields directory',"s");

if isempty(rootdir)
    rootdir = 'H:\ExportData\alldata(tests)\FIELDS';
end

A = [0.25 0.25 0.25 0.25];
phi = [0 90 180 270];


allfiles = dir(rootdir);
folderNames = {allfiles([allfiles.isdir]).name};
folderNames = folderNames(~ismember(folderNames ,{'.','..'}));

if not(isfolder(strcat(rootdir,'\ProcessedFields')))
   mkdir((strcat(rootdir,'\ProcessedFields')))
end

for i = 1:length(folderNames)

% files = dir(fullfile(strcat(rootdir,'\',folderNames{1}), '**\*.nii'));
% 
% Bfields    = cell(length(files)/3,1);
% Efields    = cell(length(files)/3,1);
% sigEfields = cell(length(files)/3,1);
% a = 1; b = 1; c = 1;
% for i = 1:length(files)
%     file =  fullfile(files(i).folder,files(i).name);
% 
%     if     any(contains(file,'B-Field'))
%         Bfields{a} = file;
%         a = a+1;
%     elseif any(contains(file,'sigE-Field'))
%         Efields{b} = file;
%         b = b+1;
%     elseif any(contains(file,'E-Field'))
%         sigEfields{c} = file;
%         c = c+1;
%     end
% end
% 
% % proccess fields and save results
% if length(Bfields) ~= length(Efields) || length(Bfields) ~= length(sigEfields) || length(Efields) ~= length(sigEfields)
%     error('MissingFields')
% end

folder = strcat(rootdir,'\',folderNames{i});

% B-Field Analysis
fields = makefields(folder,'B-Field');

A = [0.25 0.25 0.25 0.25];
phi = [0 90 180 270]; % combinefields transforms to rad

field = combinefields(fields,A,phi);
Bfield = field;

B1plus = (field(:,:,:,1) - (1i * field(:,:,:,2)))/sqrt(2);
B1p(:,:,:,1) = abs(B1plus) .* 1E6;  % Complex magnitude T uo uT
B1p(:,:,:,2) = angle(B1plus);       % Phase

meanB1 = mean(nonzeros(B1p(:,:,:,1)),"all");

name = sprintf('%s_combined_B1+-Field_mean-%g',folderNames{i},meanB1);
niftiwrite(B1p(:,:,:,1),strcat(rootdir,'\ProcessedFields\',name,'.nii'));

% E-Field Analysis
fields = makefields(folder,'E-Field');


field = combinefields(fields,A,phi);
Efield = field;

E(:,:,:,1) = sqrt((field(:,:,:,1).*conj(field(:,:,:,1))).^2 + ...
                  (field(:,:,:,2).*conj(field(:,:,:,2))).^2 + ...
                  (field(:,:,:,3).*conj(field(:,:,:,3))).^2 );

E(:,:,:,2) = atan((field(:,:,:,2)+field(:,:,:,3))./field(:,:,:,1));

meanE = mean(nonzeros(E(:,:,:,1)),"all");

% name = sprintf('%s_combined_E-field_mean-%g',folderNames{i},meanE);
% niftiwrite(E(:,:,:,1),strcat(rootdir,'\ProcessedFields\',name,'.nii'));

% sigE-Field Analysis
fields = makefields(folder,'S-Field');

field = combinefields(fields,A,phi);
sigEfield = field;

sigE(:,:,:,1) = sqrt((field(:,:,:,1).*conj(field(:,:,:,1))).^2 + ...
                     (field(:,:,:,2).*conj(field(:,:,:,2))).^2 + ...
                     (field(:,:,:,3).*conj(field(:,:,:,3))).^2 );

sigE(:,:,:,2) = atan((field(:,:,:,2)+field(:,:,:,3))./field(:,:,:,1));

meansigE = mean(nonzeros(sigE(:,:,:,1)),"all");

% name = sprintf('%s_combined_S-field_mean-%g',folderNames{i},meansigE);
% niftiwrite(sigE(:,:,:,1),strcat(rootdir,'\ProcessedFields\',name,'.nii'));

% SAR Analysis
SARfield = sigEfield.*Efield;

SAR(:,:,:,1) = sqrt((SARfield(:,:,:,1).*conj(SARfield(:,:,:,1))).^2 + ...
                    (SARfield(:,:,:,2).*conj(SARfield(:,:,:,2))).^2 + ...
                    (SARfield(:,:,:,3).*conj(SARfield(:,:,:,3))).^2 );

SAR(:,:,:,2) = atan((SARfield(:,:,:,2)+SARfield(:,:,:,3))./SARfield(:,:,:,1));

meanSAR = mean(nonzeros(SAR(:,:,:,1)),"all");

name = sprintf('%s_combined_SAR_mean-%g',folderNames{i},meanSAR);
niftiwrite(SAR(:,:,:,1),strcat(rootdir,'\ProcessedFields\',name,'.nii'));

% SAR Efficiency

SAReff = B1p(:,:,:,1)./sqrt(SAR(:,:,:,1)); %try nonzeros
SAReff(isnan(SAReff))=0;
SAReff(SAReff == inf)=0;

meanSAReff = mean(nonzeros(SAReff(:,:,:,1)),"all");

name = sprintf('%s_combined_SAReff_mean-%g',folderNames{i},meanSAReff);
niftiwrite(SAReff,strcat(rootdir,'\ProcessedFields\',name,'.nii'));

% B1/sqrt(Average SAR)

mSAReff = B1p(:,:,:,1)./sqrt(meanSAR);

meanmSAReff = mean(nonzeros(mSAReff(:,:,:,1)),"all");

name = sprintf('%s_combined_mSAReff_mean-%g',folderNames{i},meanmSAReff);
niftiwrite(mSAReff,strcat(rootdir,'\ProcessedFields\',name,'.nii'));

end
fclose all;

rootdir = strcat(rootdir,'\ProcessedFields');
delimiter = '_';

files = dir(fullfile(rootdir, '*.nii'));

for i = 1:length(files)
    filename = files(i).name;
    idx = strfind(filename,delimiter);

    folder = filename(1:idx-1);
    if not(isfolder(strcat(rootdir,'\',folder)))
        mkdir(strcat(rootdir,'\',folder))
    end
    file =  fullfile(files(i).folder,files(i).name);
    movefile(file,strcat(rootdir,'\',folder));
end
