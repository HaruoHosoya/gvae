function x=add_separator(x,col,pos,wid)

if ~exist('pos','var') pos='b'; end
if ~exist('wid','var') wid=1; end

[W,H,D,M,N]=size(x);

if D==1 x=cat(3,x,x,x); end

col=reshape(col,1,1,3);
switch(pos)
    case 'v'
        x=cat(2,repmat(col,W,wid,1,M,N),x,repmat(col,W,wid,1,M,N));
    case 'h'
        x=cat(1,repmat(col,wid,H,1,M,N),x,repmat(col,wid,H,1,M,N));
    case 'b'
        x=cat(2,repmat(col,W,wid,1,M,N),x,repmat(col,W,wid,1,M,N));
        x=cat(1,repmat(col,wid,H+2*wid,1,M,N),x,repmat(col,wid,H+2*wid,1,M,N));
end

end
