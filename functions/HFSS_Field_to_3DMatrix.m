function Output = HFSS_Field_to_3DMatrix(file)

Import = importdata(file);


Volume = struct;
Volume.info = cell2mat(Import.textdata(1,1));
Volume.coordinates = str2double(regexp(Volume.info,'[+-]?\d+\.?\d*','match'));
Volume.coordinates = reshape(Volume.coordinates,[3,3]);
Volume.units = Volume.info(find(Volume.info == num2str(Volume.coordinates(end)), 1, 'last')+1 : find(Volume.info == ']', 1, 'last')-1);

Output.x = zeros(floor((Volume.coordinates(1,2)-Volume.coordinates(1,1))/Volume.coordinates(1,3))+1,floor((Volume.coordinates(2,2)-Volume.coordinates(2,1))/Volume.coordinates(2,3))+1,floor((Volume.coordinates(3,2)-Volume.coordinates(3,1))/Volume.coordinates(3,3))+1);
Output.y = Output.x;
Output.z = Output.x;

coordinates = Import.data(:,1:3);

switch size(Import.data,2)
    case 9
        field = complex(Import.data(:,[4,6,8]),Import.data(:,[5,7,9]));
    case 6
        field = Import.data(:,4:end);
    otherwise
        error('Check field data')
end

switch Volume.units
    case 'mm'
        SI = 1000;
    case 'm'
        SI = 1;
    case 'in'
        SI = 0.0254;
    otherwise
        error('Unit Not supported')
end

idx = int32((coordinates.*SI - Volume.coordinates(:,1)')./ Volume.coordinates(:,3)' +1);

for c = 1:length(idx)
Output.x(idx(c,1),idx(c,2),idx(c,3)) = field(c,1);
Output.y(idx(c,1),idx(c,2),idx(c,3)) = field(c,2);
Output.z(idx(c,1),idx(c,2),idx(c,3)) = field(c,3);
end

end

