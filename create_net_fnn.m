function net=create_net_fnn(ndims0,xdim,ydim,zdim,varargin)

pr=inputParser;
pr.addParamValue('use_bias',true,@islogical);
pr.addParamValue('prior','gaussian',@isstr);
pr.addParamValue('rho',1,@isnumeric);
pr.addParamValue('init_value_mag',0.01,@isnumeric);
pr.addParamValue('use_relu',true,@islogical);
pr.addParamValue('use_sigmoid',false,@islogical);

pr.parse(varargin{:});
options=pr.Results;

if options.use_relu
    nlin0=cellfun(@(x)'relu',num2cell(ndims0),'UniformOutput',false);
elseif options.use_sigmoid
    nlin0=cellfun(@(x)'sigmoid',num2cell(ndims0),'UniformOutput',false);
else
    nlin0=cellfun(@(x)'softplus',num2cell(ndims0),'UniformOutput',false);
end

ndims=[ydim+zdim; ndims0(end-1:-1:2)'; xdim];
nlin={'' nlin0{end-1:-1:2} 'linear'};
net.gnet=dnet_create(ndims,nlin,options,options.rho,1);
 
ndims=[xdim; ndims0(2:end-1)'; ydim];
nlin={'' nlin0{2:end-1} 'linear'};
net.ynet_mu=dnet_create(ndims,nlin,options,1,options.rho);

ndims=[xdim; ndims0(2:end-1)'; ydim];
nlin={'' nlin0{2:end-1} 'expsqrt'};
net.ynet_pr=dnet_create(ndims,nlin,options,1,options.rho);

ndims=[xdim; ndims0(2:end-1)'; zdim];
nlin={'' nlin0{2:end-1} 'linear'};
net.znet_mu=dnet_create(ndims,nlin,options,1,options.rho);

ndims=[xdim; ndims0(2:end-1)'; zdim];
nlin={'' nlin0{2:end-1} 'expsqrt'};
net.znet_pr=dnet_create(ndims,nlin,options,1,options.rho);

net.rho=options.rho;
net.xdim=xdim;
net.ydim=ydim;
net.zdim=zdim;
net.prior=options.prior;
net.use_relu=options.use_relu;
    
end

function dnet=dnet_create(gndims,nlin,options,in_sd,out_sd)

if ~isnan(options.init_value_mag)
    dnet=dnet_create_aux(gndims,nlin,options.use_bias,options.init_value_mag);
else
    mag=0.01;
    dnet=dnet_create_aux(gndims,nlin,options.use_bias,mag);
    x=[randn(gndims(1),1000)*in_sd];
    res=vl_simplenn(dnet,shiftdim(x,-2)); y=reshape(res(end).x,gndims(end),[]);
    out_sd2=sqrt(sum(sum(y.^2,1),2)/1000);
    mag=0.01*nthroot(out_sd/out_sd2,length(gndims)-1);
    dnet=dnet_create_aux(gndims,nlin,options.use_bias,mag);
end

end

function dnet=dnet_create_aux(gndims,nlin,use_bias,f)

% num_type='single';
num_type='double';

dnet.layers = {} ;
for I=2:length(gndims)
    if use_bias
        b=zeros(1, gndims(I), num_type);
    else
        b=[];
    end
    dnet.layers{end+1} = struct('type', 'conv', ...
                                'weights', {{f*randn(1,1,gndims(I-1),gndims(I), num_type), b}}, ...
                                'stride', 1, ...
                                'pad', 0) ;
    switch(nlin{I})
        case 'relu'                
            dnet.layers{end+1} = struct('type', 'relu');
        case 'sigmoid'                
            dnet.layers{end+1} = struct('type', 'sigmoid');
        case 'softplus'                
            dnet.layers{end+1} = struct('type', 'custom','forward',@nonlin_forward_softplus,'backward',@nonlin_backward_softplus);
        case 'square'
            dnet.layers{end+1} = struct('type', 'custom','forward',@nonlin_forward_square,'backward',@nonlin_backward_square);
        case 'expsqrt'
            dnet.layers{end+1} = struct('type', 'custom','forward',@nonlin_forward_expsqrt,'backward',@nonlin_backward_expsqrt);
        case 'linear'
    end
end

dnet=vl_simplenn_tidy(dnet);

end

function res_next=nonlin_forward_softplus(lay,res,res_next)
    [res_next.x,res_next.aux]=nonlin('softplus',res.x,0.5);
end

function res=nonlin_backward_softplus(lay,res,res_next)
    [~,d]=nonlin('softplus',res.x,0.5);
    res.dzdx=res_next.dzdx.*d;
end

function res_next=nonlin_forward_square(lay,res,res_next)
    [res_next.x,res_next.aux]=nonlin('square',res.x,1);
end

function res=nonlin_backward_square(lay,res,res_next)
    [~,d]=nonlin('square',res.x,1);
    res.dzdx=res_next.dzdx.*d;
end

function res_next=nonlin_forward_expsqrt(lay,res,res_next)
    [res_next.x,res_next.aux]=nonlin('expsqrt',res.x,1);
end

function res=nonlin_backward_expsqrt(lay,res,res_next)
    [~,d]=nonlin('expsqrt',res.x,1);
    res.dzdx=res_next.dzdx.*d;
end
