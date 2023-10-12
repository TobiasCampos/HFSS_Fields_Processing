function [Field] = Read_HFSS_Fields(directory,filename)

fprintf('Reading fields from: %s\n',filename)

Import = importdata(strcat(directory,'\',filename));

switch size(Import.data,2)
    case 9
        field = complex(Import.data(:,[4,6,8]),Import.data(:,[5,7,9]));
    case 6
        field = Import.data(:,4:end);
    case 4
        field = Import.data(:,4);
    otherwise
        error('Check field data')
end

coordinates = Import.data(:,1:3).*1000; %m to mm
Field.name = filename;
Field.x = zeros(floor((max(coordinates(:,1)) - min(coordinates(:,1))))+1,floor((max(coordinates(:,2)) - min(coordinates(:,2))))+1,floor((max(coordinates(:,3)) - min(coordinates(:,3))))+1);
Field.y = Field.x;
Field.z = Field.x;

CScorrection = [min(coordinates(:,1)),min(coordinates(:,2)),min(coordinates(:,3))];

idx = int32((coordinates - CScorrection)+1);

for i = 1:length(idx)
    Field.x(idx(i,1),idx(i,2),idx(i,3)) = field(i,1);
    Field.y(idx(i,1),idx(i,2),idx(i,3)) = field(i,2);
    Field.z(idx(i,1),idx(i,2),idx(i,3)) = field(i,3);
end

end

