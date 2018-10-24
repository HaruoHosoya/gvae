function x=make_comparison_gt(net,ds,idx1,idx2,find_gt,varargin)

pr=inputParser;
pr.addParamValue('neg',false,@islogical);
pr.parse(varargin{:});
options=pr.Results;

nshow=length(idx1);

rc=cross_recon2(net,ds.images(:,:,:,idx1),ds.images(:,:,:,idx2));
gt=ds.images(:,:,:,find_gt(ds,idx1,idx2));
idx=diag(reshape(1:(nshow^2),nshow,nshow));

if options.neg rc=-rc; gt=-gt; end

x=reshape(add_separator(rc(:,:,:,idx),[-3 -3 -3],'b',1),ds.wid+2,ds.wid+2,3,[]);
x=cat(5,x,add_separator(reshape(gt(:,:,:,idx),ds.wid,ds.wid,ds.dep,[]),[-3 -3 3],'b',1));

end
