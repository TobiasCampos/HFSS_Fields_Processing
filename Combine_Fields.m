clear; clc; close all;
% NOT USED ANYMORE -> HFSS Fields Processing
addpath functions\

rootdir = input('enter fields directory',"s");

if isempty(rootdir)
    rootdir = 'H:\ExportData\alldata(tests)\tests';
end

% B-Field Analysis
fields = makefields(rootdir,'B-Field');

A = [0.25 0.25 0.25 0.25];
phi = [0 90 180 270]; % combinefields transforms to rad

field = combinefields(fields,A,phi);
Bfield = field;

B1plus = (field(:,:,:,1) - (1i * field(:,:,:,2)))/sqrt(2);
B1p(:,:,:,1) = abs(B1plus) .* 1E6;  % Complex magnitude T uo uT
B1p(:,:,:,2) = angle(B1plus);       % Phase

meanB1 = mean(nonzeros(B1p(:,:,:,1)),"all");

name = sprintf('%scombined_B-field_mean-%g',folderNames{1},meanB1);
niftiwrite(B1p(:,:,:,1),strcat(rootdir,'\',name,'.nii'));

% E-Field Analysis
fields = makefields(rootdir,'E-Field');


field = combinefields(fields,A,phi);
Efield = field;

E(:,:,:,1) = sqrt((field(:,:,:,1).*conj(field(:,:,:,1))).^2 + ...
                  (field(:,:,:,2).*conj(field(:,:,:,2))).^2 + ...
                  (field(:,:,:,3).*conj(field(:,:,:,3))).^2 );

E(:,:,:,2) = atan((field(:,:,:,2)+field(:,:,:,3))./field(:,:,:,1));

meanE = mean(nonzeros(E(:,:,:,1)),"all");

% name = sprintf('combined_E-field_mean-%g',meanE);
% niftiwrite(E(:,:,:,1),strcat(rootdir,'\',name,'.nii'));

% sigE-Field Analysis
fields = makefields(rootdir,'S-Field');

field = combinefields(fields,A,phi);
sigEfield = field;

sigE(:,:,:,1) = sqrt((field(:,:,:,1).*conj(field(:,:,:,1))).^2 + ...
                     (field(:,:,:,2).*conj(field(:,:,:,2))).^2 + ...
                     (field(:,:,:,3).*conj(field(:,:,:,3))).^2 );

sigE(:,:,:,2) = atan((field(:,:,:,2)+field(:,:,:,3))./field(:,:,:,1));

meansigE = mean(nonzeros(sigE(:,:,:,1)),"all");

% name = sprintf('combined_sigE-field_mean-%g',meansigE);
% niftiwrite(sigE(:,:,:,1),strcat(rootdir,'\',name,'.nii'));

% SAR Analysis
SARfield = sigEfield.*Efield;

SAR(:,:,:,1) = sqrt((SARfield(:,:,:,1).*conj(SARfield(:,:,:,1))).^2 + ...
                    (SARfield(:,:,:,2).*conj(SARfield(:,:,:,2))).^2 + ...
                    (SARfield(:,:,:,3).*conj(SARfield(:,:,:,3))).^2 );

SAR(:,:,:,2) = atan((SARfield(:,:,:,2)+SARfield(:,:,:,3))./SARfield(:,:,:,1));

meanSAR = mean(nonzeros(SAR(:,:,:,1)),"all");

name = sprintf('combined_SAR-field_mean-%g',meanSAR);
niftiwrite(SAR(:,:,:,1),strcat(rootdir,'\',name,'.nii'));

% SAR Efficiency

SAReff = B1p(:,:,:,1)./sqrt(SAR(:,:,:,1));
SAReff(isnan(SAReff))=0;
SAReff(SAReff == inf)=0;

meanSAReff = mean(nonzeros(SAReff(:,:,:,1)),"all");

name = sprintf('combined_SAReff-field_mean-%g',meanSAReff);
niftiwrite(SAReff,strcat(rootdir,'\',name,'.nii'));



