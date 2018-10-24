function [L,gradnet]=obj_gvae(net,x_obs_list,epsy,epsz)

    % ..._pr is in fact ..._var

    [W,H,D,N,K]=size(x_obs_list);    
    x_obs=reshape(x_obs_list,W,H,D,N*K);
    
    epsy=reshape(epsy,1,1,net.ydim,N*K);
    epsz=reshape(epsz,1,1,net.zdim,N);

    % x1->z1, ..., xk->zk
    % z=average(z1,..,zk)
    
    z_mu_res=vl_simplenn(net.znet_mu,x_obs); z_mu=z_mu_res(end).x;
    z_pr_res=vl_simplenn(net.znet_pr,x_obs); z_pr=z_pr_res(end).x;
    
    z_pr_ave=sum(reshape(z_pr,1,1,net.zdim,N,K),5)/K;
    z_mu_ave=sum(reshape(z_mu,1,1,net.zdim,N,K),5)/K;
    
    % x1->y1, .., xk->yk
    
    y_mu_res=vl_simplenn(net.ynet_mu,x_obs); y_mu=y_mu_res(end).x;
    y_pr_res=vl_simplenn(net.ynet_pr,x_obs); y_pr=y_pr_res(end).x;
 
    % y1,z->x1, ..., yk,z->xk
    
    y_est=y_mu+sqrt(y_pr).*epsy;
    z_est=z_mu_ave+sqrt(z_pr_ave).*epsz;    
    yz_est=cat(3,y_est,repmat(z_est,1,1,1,K));
    x_res=vl_simplenn(net.gnet,yz_est); x=x_res(end).x;

    % variational lower bound
    
    L=-1/2/net.rho^2*sum(sum(sum(sum((x_obs-x).^2,1),2),3),4);
    L=L+1/2*sum(sum(1+log(z_pr_ave)-z_mu_ave.^2-z_pr_ave,3),4);
    L=L+1/2*sum(sum(sum(1+log(y_pr)-y_mu.^2-y_pr,3),4),5);    
    L=L/N;

    % backprop y1,z<-x1, ..., yk,z<-xk

    x_err=(x_obs-x)/N/net.rho^2;
    x_res=vl_simplenn(net.gnet,yz_est,x_err,x_res,'skipForward',true);

    % backprop x1<-y1, ..., xk<-yk
    
    y_mu_err=x_res(1).dzdx(1,1,1:net.ydim,:);
    y_mu_err=y_mu_err-y_mu/N; 
    y_mu_res=vl_simplenn(net.ynet_mu,x_obs,y_mu_err,y_mu_res,'skipForward',true);

    y_pr_err=y_pr.^(-1/2)/2 .* x_res(1).dzdx(1,1,1:net.ydim,:).*epsy;
    y_pr_err=y_pr_err + (1./y_pr-1)/N/2;
    y_pr_res=vl_simplenn(net.ynet_pr,x_obs,y_pr_err,y_pr_res,'skipForward',true);
    
    % backprop x1<-z, ..., xk<-z

    z_mu_err=sum(reshape(x_res(1).dzdx(1,1,net.ydim+1:end,:),1,1,net.zdim,N,K),5)/K;
    z_mu_err=z_mu_err-z_mu_ave/N; 
    z_mu_err=repmat(z_mu_err,1,1,1,K);
    z_mu_res=vl_simplenn(net.znet_mu,x_obs,z_mu_err,z_mu_res,'skipForward',true);
    
    z_pr_err=z_pr_ave.^(-1/2)/2 .* sum(reshape(x_res(1).dzdx(1,1,net.ydim+1:end,:),1,1,net.zdim,N,K),5)/K .* epsz;
    z_pr_err=z_pr_err + (1./z_pr_ave-1)/N/2;
    z_pr_err=repmat(z_pr_err,1,1,1,K);
    z_pr_res=vl_simplenn(net.znet_pr,x_obs,z_pr_err,z_pr_res,'skipForward',true);

    gradnet=net;
    gradnet.gnet.res=x_res;
    gradnet.ynet_mu.res=y_mu_res;
    gradnet.ynet_pr.res=y_pr_res;
    gradnet.znet_mu.res=z_mu_res;
    gradnet.znet_pr.res=z_pr_res;
        
end

