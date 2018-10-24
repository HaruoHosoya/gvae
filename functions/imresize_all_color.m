function imgs_out=imresize_all_color(imgs,sz)

imgs_out=zeros(sz(1),sz(2),size(imgs,3),size(imgs,4));

for I=1:size(imgs,4)
    imgs_out(:,:,:,I)=imresize(imgs(:,:,:,I),sz);
end;

end


    