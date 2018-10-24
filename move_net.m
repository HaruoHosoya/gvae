function net=move_net(net,proc)

net.gnet=vl_simplenn_move(net.gnet,proc);
net.ynet_mu=vl_simplenn_move(net.ynet_mu,proc);
net.znet_mu=vl_simplenn_move(net.znet_mu,proc);
net.ynet_pr=vl_simplenn_move(net.ynet_pr,proc);
net.znet_pr=vl_simplenn_move(net.znet_pr,proc);

if isfield(net,'cnet')
    net.cnet=vl_simplenn_move(net.cnet,proc);
end

end

