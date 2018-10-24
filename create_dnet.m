function dnet=create_dnet(arch,ncla,varargin)

pr=inputParser;
pr.addParamValue('color',true,@islogical);
pr.addParamValue('init_value_mag',0.01,@isnumeric);
pr.parse(varargin{:});
options=pr.Results;

f=options.init_value_mag;

dnet=create_net(arch,'color',options.color,'init_value_mag',options.init_value_mag);

dnet.cnet.layers{1}=struct('type','relu');
dnet.cnet.layers{2}=struct('type','conv','weights',{cnn_weight(1,1,dnet.zdim,ncla,f)},'stride',1,'pad',0);
dnet.cnet.layers{3}=struct('type','softmax');
dnet.cnet=vl_simplenn_tidy(dnet.cnet);

end

