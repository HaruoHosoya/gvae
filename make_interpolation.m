function x=make_interpolation(net,ds,idx1,idx2,grid1,grid2,varargin)

pr=inputParser;
pr.addParamValue('neg',false,@islogical);
pr.parse(varargin{:});
options=pr.Results;

d1=ds.images(:,:,:,idx1);
d2=ds.images(:,:,:,idx2);

d=cat(4,d1,d2);

res=vl_simplenn(net.znet_mu,d); 
z=reshape(res(end).x,net.zdim,2);

res=vl_simplenn(net.ynet_mu,d);
y=reshape(res(end).x,net.ydim,2);

[zr,yr]=ndgrid(grid2,grid1);

% polar interpolation for y

% A=[[norm(y(:,2)) 0 0]' [0 norm(y(:,1)) 0]' [0 0 norm(y(:,2))*norm(y(:,1))]'] * inv([y(:,2) y(:,1) cross(y(:,2),y(:,1))]);
% y_tran=A*y;
% y_rad=sqrt(y_tran(2,:).^2+y_tran(1,:).^2);
% y_the=atan2(y_tran(2,:),y_tran(1,:));
% 
% yy_rad=y_rad(:,2)*yr(:)'+y_rad(:,1)*(1-yr(:)');
% yy_the=y_the(:,2)*yr(:)'+y_the(:,1)*(1-yr(:)');
% yy_tran=[[cos(yy_the).*yy_rad]; [sin(yy_the).*yy_rad]; zeros(1,length(zr(:)))];
% yy=inv(A)*yy_tran;

% cartesian interpolation for y

yy=y(:,2)*yr(:)'+y(:,1)*(1-yr(:)');

zz=z(:,2)*zr(:)'+z(:,1)*(1-zr(:)');

yy=reshape(yy,1,1,net.ydim,[]);
zz=reshape(zz,1,1,net.zdim,[]);

res=vl_simplenn(net.gnet,cat(3,yy,zz)); 
x=reshape(res(end).x,ds.wid,ds.wid,ds.dep,[]);

if options.neg x=-x; d=-d; end

i1=find(yr(:)==0 & zr(:)==0);
i2=find(yr(:)==1 & zr(:)==1);

xb=x(:,:,:,1:i1-1);
x1=x(:,:,:,i1);
xm=x(:,:,:,i1+1:i2-1);
x2=x(:,:,:,i2);
xe=x(:,:,:,i2+1:end);

xb=add_separator(xb,[-3 -3 -3],'b',1);
x1=add_separator(x1,[-3 3 -3],'b',1);
xm=add_separator(xm,[-3 -3 -3],'b',1);
x2=add_separator(x2,[-3 3 -3],'b',1);
xe=add_separator(xe,[-3 -3 -3],'b',1);
x=cat(4,xb,x1,xm,x2,xe);

         
end
