function trx=cross_recon2(net,tr1,tr2)

[W,H,D,N1,K1]=size(tr1);
[~,~,~,N2,K2]=size(tr2);

if K1~=1 || K2~=1 
    error('no grouped data accepted'); 
end

res=vl_simplenn(net.znet_mu,tr1); 
trz1=reshape(res(end).x,1,1,net.zdim,N1);

res=vl_simplenn(net.ynet_mu,tr2);
try2=reshape(res(end).x,1,1,net.ydim,N2);

[zi,yi]=ndgrid(1:N1,1:N2);
trz0=trz1(:,:,:,zi(:));
try0=try2(:,:,:,yi(:));

res=vl_simplenn(net.gnet,reshape(cat(3,try0,trz0),1,1,net.ydim+net.zdim,N1*N2)); 
trx=reshape(res(end).x,W,H,D,N1*N2);

end
