function [trx11,trx12,trx21,trx22]=cross_recon(net,tr1,tr2)

[W,H,D,N,K]=size(tr1);

res=vl_simplenn(net.znet_mu,reshape(tr1,W,H,D,N*K)); 
trz_mu=reshape(res(end).x,1,1,net.zdim,N,K);

if net.averaging
    trz1=mean(trz_mu,5);
else
    res=vl_simplenn(net.znet_pr,reshape(tr1,W,H,D,N*K));
    trz_pr=reshape(res(end).x,1,1,net.zdim,N,K);
    trz1=sum(trz_mu.*trz_pr,5)./sum(trz_pr,5);    
end

res=vl_simplenn(net.znet_mu,reshape(tr2,W,H,D,N*K)); 
trz_mu=reshape(res(end).x,1,1,net.zdim,N,K);

if net.averaging
    trz2=mean(trz_mu,5);
else
    res=vl_simplenn(net.znet_pr,reshape(tr2,W,H,D,N*K));
    trz_pr=reshape(res(end).x,1,1,net.zdim,N,K);
    trz2=sum(trz_mu.*trz_pr,5)./sum(trz_pr,5);    
end

res=vl_simplenn(net.ynet_mu,reshape(tr1,W,H,D,N*K));
try1=reshape(res(end).x,1,1,net.ydim,N,K);
res=vl_simplenn(net.ynet_mu,reshape(tr2,W,H,D,N*K));
try2=reshape(res(end).x,1,1,net.ydim,N,K);

res=vl_simplenn(net.gnet,reshape(cat(3,try1,trz1),1,1,net.ydim+net.zdim,N*K)); 
trx11=reshape(res(end).x,W,H,D,N,K);
res=vl_simplenn(net.gnet,reshape(cat(3,try2,trz1),1,1,net.ydim+net.zdim,N*K)); 
trx21=reshape(res(end).x,W,H,D,N,K);

res=vl_simplenn(net.gnet,reshape(cat(3,try1,trz2),1,1,net.ydim+net.zdim,N*K)); 
trx12=reshape(res(end).x,W,H,D,N,K);
res=vl_simplenn(net.gnet,reshape(cat(3,try2,trz2),1,1,net.ydim+net.zdim,N*K)); 
trx22=reshape(res(end).x,W,H,D,N,K);

end
