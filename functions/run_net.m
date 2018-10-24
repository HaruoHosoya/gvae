function net=run_net(net,dataset,varargin)

pr=inputParser;
pr.addParamValue('use_filter',false,@islogical);

pr.parse(varargin{:});
options=pr.Results;

fprintf('running net...');

dataset=dataset';
[datalen,~]=size(dataset);

info=net.structure.layers;

net.content.layers{1}.unitProperties.resp=reshape(dataset,datalen,info{1}.numUnits,info{1}.width^2);

for L=2:length(net.content.layers)
    fprintf('[layer %d]',L);
    layer=net.content.layers{L};
    lower=net.content.layers{L-1};
    numUnits=info{L}.numUnits;
    numNodes=info{L}.width^2;
    lowerNumUnits=info{L-1}.numUnits;
    lowerWidth=info{L-1}.width;
    patchWidth=info{L-1}.patchWidth;
    resp=zeros(datalen,numUnits,numNodes);
    for N=1:numNodes
        relcov=layer.nodeProperties.relcover;
        x=relcov(N,1); y=relcov(N,2); w=relcov(N,3); h=relcov(N,4);
        [xi,yi]=ndgrid(x:x+w-1,y:y+h-1);
        lowerNodes=sub2ind([lowerWidth,lowerWidth],xi,yi);
        inp=reshape(lower.unitProperties.resp(:,:,lowerNodes),[datalen,lowerNumUnits*patchWidth^2]);
        if isfield(layer.layerProperties,'meanrem') && layer.layerProperties.meanrem
            inp=bsxfun(@minus,inp,layer.mean);
        end;
        if isfield(layer.layerProperties,'meanproj') && layer.layerProperties.meanproj
            inp=inp-(inp*layer.mean')*layer.mean/sum(layer.mean.^2);
        end;
        if options.use_filter
            weights=layer.filters(:,:,:,N);
        else
            weights=layer.weights(:,:,:,N);
        end;
        weights=reshape(weights,[lowerNumUnits*patchWidth^2,numUnits]);
        r=nonlinop(inp*weights,layer.layerProperties.nonlin);
        if layer.layerProperties.dcrem
            r=bsxfun(@minus,r,mean(r,2));
        end;
        resp(:,:,N)=r;
    end;
    net.content.layers{L}.unitProperties.resp=resp;    
end;


fprintf('\n');

end
