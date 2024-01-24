function combinedfield = combinefields(fields,A,phi)
% fields in a MxNxOx(xyz)x(number of channels) (5d matrix)
% A is a 1d vector containing amplitude scaling factors
% phi is a 1d vector containing phase scailing factor
% the dimention of A and phi is = size(fields,5)

if max(phi) > 6.284 %if any angle is greater than 2*pi then the angles are in degrees (likely)
    phi = deg2rad(phi);
end

combinedfield = zeros(size(fields,1),size(fields,2),size(fields,3),3);

for n = 1:size(fields,5)
    field = complex(fields(:,:,:,[1,3,5],n),fields(:,:,:,[2,4,6],n));
    scaled_field = A(n).*field.*exp(1i*phi(n)); % e^-j in "rf-shimming"
    combinedfield = combinedfield + scaled_field;
end
combinedfield = combinedfield.*sqrt(n); % rescale fields assuming each channel is 1W 0deg
end