function [L,gradnet]=obj_dnet(net,x_obs,c_obs)

    N=size(x_obs,4);
    z_res=vl_simplenn(net.znet_mu,x_obs);
    z=z_res(end).x;
    c_res=vl_simplenn(net.cnet,z);
    
    L=-1/2*sum(sum((c_obs-c_res(end).x).^2,3),4)/N;
    
    c_err=(c_obs-c_res(end).x)/N;
    c_res=vl_simplenn(net.cnet,z,c_err,c_res,'skipForward',true);
    z_err=c_res(1).dzdx;
    z_res=vl_simplenn(net.znet_mu,x_obs,z_err,z_res,'skipForward',true);
    
    gradnet=net;
    gradnet.znet_mu.res=z_res;
    gradnet.cnet.res=c_res;
    
end
