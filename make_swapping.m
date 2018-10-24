function [x,xo]=make_swapping(net,ds,idx1,idx2,varargin)

pr=inputParser;
pr.addParamValue('neg',false,@islogical);
pr.parse(varargin{:});
options=pr.Results;

nshow1=length(idx1);
nshow2=length(idx2);

d1=ds.images(:,:,:,idx1);
d2=ds.images(:,:,:,idx2);

xo=cross_recon2(net,d1,d2);
if options.neg xo=-xo; d1=-d1; d2=-d2; end

x=reshape(add_separator(xo,[-3 -3 -3],'b',1),ds.wid+2,ds.wid+2,3,nshow1,nshow2);
x=cat(5,add_separator(d1,[3 -3 -3],'b',1),x);
x=cat(4,cat(5,ones(ds.wid+2,ds.wid+2,3,1,1)*3,...
              reshape(add_separator(d2,[3 -3 -3],'b',1),ds.wid+2,ds.wid+2,3,1,nshow2)),...
        x);

         
end
