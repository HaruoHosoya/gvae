function net=learn_dnet(net,input,output,varargin)

pr=inputParser;
pr.addParamValue('MaxIter',200,@isnumeric);
pr.addParamValue('DerivativeCheck','off',@isstr);
pr.addParamValue('TolX',1e-4,@isnumeric);
pr.addParamValue('initialize',true,@islogical);
pr.addParamValue('save_dir',[],@isstr);
pr.addParamValue('save_interval',2000,@isnumeric);
pr.addParamValue('batchSize',100,@isnumeric);
pr.addParamValue('batchSplit',1,@isnumeric);
pr.addParamValue('initialRate',1e-3,@isnumeric);
pr.addParamValue('gpu',false,@islogical);

pr.parse(varargin{:});
options=pr.Results;

%%

if options.gpu
    net=move_net(net,'gpu');
end

[W,H,D,N]=size(input);

X0=compose(net);

if isequal(options.DerivativeCheck,'on')
    opts = optimset('Display','off', 'Algorithm', 'interior-point', ...
        'TolFun', 1e-4, 'TolX', options.TolX, 'MaxFunEvals', 5000,'GradObj','on','DerivativeCheck','on');
    [X,ll]=fminunc(@(x)obj_aux(x,1),X0,opts);
else
%     opts.Method='lbfgs';
%     opts.MaxFunEvals=Inf;
%     opts.maxIter=options.MaxIter;
%     opts.outputFcn=@outfun;
%     tic;
%     [X,ll]=minFunc(@obj_aux,X0,opts);
%     toc
% end

opts=optimset('MaxFunEvals',Inf,'MaxIter',options.MaxIter,'OutputFcn',@outfun,...
    'DerivativeCheck',options.DerivativeCheck,'GradObj','on','Display','iter');
X_prev=X0;
tic;
[X,ll]=fmin_adam(@obj_aux,X0,options.initialRate,[],[],[],10,opts);
toc
end

net=decompose(net,X);

if options.gpu
    net=move_net(net,'cpu');
end

    function [L,grad]=obj_aux(X,niter)
        if isequal(options.DerivativeCheck,'on')
            sta=mod((niter-1)*options.batchSize,N)+1; 
            idx=sta:sta+options.batchSize-1;
            datx=input(:,:,:,idx);
            datz=output(:,:,:,idx);
        else            
            idx=randi(N,options.batchSize,1);
            datx=input(:,:,:,idx);
            datz=output(:,:,:,idx);
        end
        if options.gpu
            datx=gpuArray(datx);
            datz=gpuArray(datz);
        end
        net1=decompose(net,X);
        L=0; grad=0;
        for M=1:options.batchSplit
            r=options.batchSize/options.batchSplit;
            datx1=datx(:,:,:,(M-1)*r+1:M*r); 
            datz1=datz(:,:,:,(M-1)*r+1:M*r); 
            [L1,gradnet1]=obj_dnet(net1,datx1,datz1);
            L=L+L1; grad=grad+compose_grad(gradnet1);
        end
        L=-L/options.batchSplit;
        grad=-grad/options.batchSplit;
    end

    function X=compose(net)
        X=[dnet_deflate(net.znet_mu);dnet_deflate(net.cnet)]; 
    end

    function X=compose_grad(net)
        X=[dnet_deflate_grad(net.znet_mu);dnet_deflate_grad(net.cnet)]; 
    end

    function net=decompose(net,X)
        [net.znet_mu,X]=dnet_inflate(net.znet_mu,X);
        [net.cnet,~]=dnet_inflate(net.cnet,X);
    end
        
%     function stop=outfun(X,iterType,iternum,funEvals,f,t,gtd,g,d,optCond,varargin)
    function stop=outfun(X,optimValues,state)
       stop=false;
       if isempty(options.save_dir) return; end;
       if optimValues.iteration==0
           mkdir(options.save_dir); 
       elseif mod(optimValues.iteration,options.save_interval)==0
           net_tmp=decompose(net,X);
           net_tmp=move_net(net_tmp,'cpu');
           fname=sprintf('net_tmp.%08d.mat',optimValues.iteration);
           net_tmp.dir_name=options.save_dir;
           net_tmp.file_name=fname;
           save([options.save_dir '/' fname],'net_tmp');
%            if isequal(X_prev,X) stop=true; end;
%            X_prev=X;
       end
    end

end

function X=dnet_deflate(dnet)

X=[];
for I=1:length(dnet.layers)
    switch(dnet.layers{I}.type)
        case {'conv','convt'}
            X=[X; dnet.layers{I}.weights{1}(:); dnet.layers{I}.weights{2}(:)];
    end
end

end

function X=dnet_deflate_grad(dnet)

X=[];
for I=1:length(dnet.layers)
    switch(dnet.layers{I}.type)
        case {'conv','convt'}
            X=[X; dnet.res(I).dzdw{1}(:); dnet.res(I).dzdw{2}(:)];
    end
end

end

function [dnet,X]=dnet_inflate(dnet,X)

for I=1:length(dnet.layers)
    switch(dnet.layers{I}.type)
        case {'conv','convt'}
            n=numel(dnet.layers{I}.weights{1});
            dnet.layers{I}.weights{1}(:)=X(1:n);
            X(1:n)=[];
            n=numel(dnet.layers{I}.weights{2});
            dnet.layers{I}.weights{2}(:)=X(1:n);
            X(1:n)=[];
    end
end

end

            
