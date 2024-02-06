function MagPhase = magphase(field)
%MAGPHASE Summary of this function goes here

MagPhase(:,:,:,1) = sqrt((field(:,:,:,1).*conj(field(:,:,:,1))) + ...
                         (field(:,:,:,2).*conj(field(:,:,:,2))) + ...
                         (field(:,:,:,3).*conj(field(:,:,:,3))) );

MagPhase(:,:,:,2) = atan((field(:,:,:,2)+field(:,:,:,3))./field(:,:,:,1));

end