function imgs=high_pass_filter(imgs)

[sx,sy,len]=size(imgs);

[ix,iy]=ndgrid(-20:20,-20:20);

in_rad=0.5;
out_rad=1;

filt_plus=exp(-(ix.^2+iy.^2)/(2*in_rad^2));
filt_minus=exp(-(ix.^2+iy.^2)/(2*out_rad^2));
filt=filt_plus/sum(filt_plus(:))-filt_minus/sum(filt_minus(:));

for I=1:len
    imgs(:,:,I)=conv2(imgs(:,:,I),filt,'same');
end;

end
