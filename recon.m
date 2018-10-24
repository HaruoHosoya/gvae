function [trx1,try1,trz1]=recon(net,tr1)

[W,H,D,N1,K1]=size(tr1);

res=vl_simplenn(net.znet_mu,tr1); 
trz_mu=reshape(res(end).x,1,1,net.zdim,N1,K1);

if net.averaging
    trz1=mean(trz_mu,5);
else
    res=vl_simplenn(net.znet_pr,tr1);
    trz_pr=reshape(res(end).x,1,1,net.zdim,N1,K1);
    trz1=sum(trz_mu.*trz_pr,5)./sum(trz_pr,5);    
end

res=vl_simplenn(net.ynet_mu,tr1);
try1=reshape(res(end).x,1,1,net.ydim,N1,K1);

res=vl_simplenn(net.gnet,reshape(cat(3,try1,reshape(trz1,1,1,1,1,K1)),1,1,net.ydim+net.zdim,N1*K1)); 
trx1=reshape(res(end).x,W,H,D,N1,K1);

end
