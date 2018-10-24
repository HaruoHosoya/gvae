function net=create_net(arch_num,varargin)

pr=inputParser;
pr.addParamValue('color',true,@islogical);
pr.addParamValue('nonlin','relu',@isstr);
pr.addParamValue('init_value_mag',0.01,@isnumeric);
pr.parse(varargin{:});
options=pr.Results;

f=options.init_value_mag;

if options.color
    dep=3;
else
    dep=1;
end

switch arch_num
    case 1
        nfilter=64;
        ydim=3;
        zdim=100;
        fc_nunit_y=64;
        fc_nunit_z=100;
        fc_nunit_g=128;
    case 2
        nfilter=128;
        ydim=3;
        zdim=200;
        fc_nunit_y=128;
        fc_nunit_z=200;
        fc_nunit_g=200;
    case 3
        nfilter=64;
        ydim=3;
        zdim=200;
        fc_nunit_y=64;
        fc_nunit_z=100;
        fc_nunit_g=128;
end

net=struct; 
ynet=struct; 
znet=struct; 
gnet=struct;

net.arch_num=arch_num;
net.rho=1;
net.xdim=64^2*dep;
net.ydim=ydim;
net.zdim=zdim;

ynet.layers{1}=struct('type','conv','weights',{cnn_weight(5,5,dep,nfilter,f)},'stride',2,'pad',2);
ynet.layers{2}=nonlin_layer(options.nonlin);
ynet.layers{3}=struct('type','conv','weights',{cnn_weight(5,5,nfilter,nfilter,f)},'stride',2,'pad',2);
ynet.layers{4}=nonlin_layer(options.nonlin);
ynet.layers{5}=struct('type','conv','weights',{cnn_weight(5,5,nfilter,nfilter,f)},'stride',2,'pad',2);
ynet.layers{6}=nonlin_layer(options.nonlin);
ynet.layers{7}=struct('type','conv','weights',{cnn_weight(8,8,nfilter,fc_nunit_y,f)},'stride',1,'pad',0);
ynet.layers{8}=nonlin_layer(options.nonlin);
ynet.layers{9}=struct('type','conv','weights',{cnn_weight(1,1,fc_nunit_y,ydim,f)},'stride',1,'pad',0);
net.ynet_mu=vl_simplenn_tidy(ynet);

ynet.layers{10}=struct('type','custom','forward',@nonlin_forward_expsqrt,'backward',@nonlin_backward_expsqrt);
net.ynet_pr=vl_simplenn_tidy(ynet);

znet.layers{1}=struct('type','conv','weights',{cnn_weight(5,5,dep,nfilter,f)},'stride',2,'pad',2);
znet.layers{2}=nonlin_layer(options.nonlin);
znet.layers{3}=struct('type','conv','weights',{cnn_weight(5,5,nfilter,nfilter,f)},'stride',2,'pad',2);
znet.layers{4}=nonlin_layer(options.nonlin);
znet.layers{5}=struct('type','conv','weights',{cnn_weight(5,5,nfilter,nfilter,f)},'stride',2,'pad',2);
znet.layers{6}=nonlin_layer(options.nonlin);
znet.layers{7}=struct('type','conv','weights',{cnn_weight(8,8,nfilter,fc_nunit_z,f)},'stride',1,'pad',0);
znet.layers{8}=nonlin_layer(options.nonlin);
znet.layers{9}=struct('type','conv','weights',{cnn_weight(1,1,fc_nunit_z,zdim,f)},'stride',1,'pad',0);
net.znet_mu=vl_simplenn_tidy(znet);

znet.layers{10}=struct('type','custom','forward',@nonlin_forward_expsqrt,'backward',@nonlin_backward_expsqrt);
net.znet_pr=vl_simplenn_tidy(znet);

gnet.layers{1}=struct('type','convt','upsample',1,'crop',0,'weights',{cnn_weight(1,1,fc_nunit_g,ydim+zdim,f)});
gnet.layers{2}=nonlin_layer(options.nonlin);
gnet.layers{3}=struct('type','convt','upsample',1,'crop',0,'weights',{cnn_weight(8,8,nfilter,fc_nunit_g,f)});
gnet.layers{4}=nonlin_layer(options.nonlin);
gnet.layers{5}=struct('type','convt','upsample',2,'crop',2,'weights',{cnn_weight(6,6,nfilter,nfilter,f)});
gnet.layers{6}=nonlin_layer(options.nonlin);
gnet.layers{7}=struct('type','convt','upsample',2,'crop',2,'weights',{cnn_weight(6,6,nfilter,nfilter,f)});
gnet.layers{8}=nonlin_layer(options.nonlin);
gnet.layers{9}=struct('type','convt','upsample',2,'crop',2,'weights',{cnn_weight(6,6,dep,nfilter,f)});
net.gnet=vl_simplenn_tidy(gnet);

end

function l=nonlin_layer(ty)

switch ty
    case 'relu'
        l=struct('type','relu');
    case 'softplus'
        l=struct('type','custom','forward',@nonlin_forward_softplus,'backward',@nonlin_backward_softplus);
end

end


