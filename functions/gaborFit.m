function [params,residual] = gaborFit(img)
% gaborFit(img)
%  img : input image of size_x * size_y

[sx,sy]=size(img);
[ix,iy]=ndgrid(1:sx,1:sy);

    function [v,g]=obj(ps)
        [G,Gg]=gabor(ix,iy,ps);
        d=img-G;
        g=zeros(8,1);
        for J=1:8
            Gg1=Gg{J};
            g(J)=-2*sum(d(:).*Gg1(:));
        end;        
        v=sum(d(:).^2);
    end


ffreq=abs(fftshift(fft2(img)));
[~,idx]=max(ffreq(:));
[px,py]=ind2sub(size(ffreq),idx);
[pori,pfreq]=cart2pol(px-(sx/2+1),py-(sy/2+1));
pori=mod(pori,pi);
pfreq=pfreq/sx;

env=sqrt(img.^2+imag(hilbert(img)).^2);
[amp,idx]=max(env(:));
[cx,cy]=ind2sub(size(env),idx);
rad=sum(flatten(sqrt((ix-cx).^2+(iy-cy).^2).*env))/sum(env(:));

T=8;

phi=(0:T-1)*2*pi/T;

lb=[0;    0;    0;   0;   0;   0;    0;     0];
ub=[sx+1; sy+1; amp*2;   sx;  sy;  pi;   0.75;   pi*2]; 
q0=[repmat([cx; cy; amp; rad; rad; pori; pfreq],1,T); phi];
    
opts = optimset('Display','off', 'Algorithm', 'interior-point', ...
    'TolFun', 1e-4, 'TolX', 1e-4, 'MaxFunEvals', 5000,'GradObj','on','DerivativeCheck','off');

problem = createOptimProblem('fmincon','x0',q0(:,1),'objective',@obj,'lb',lb,'ub',ub,'options',opts);
searcher = MultiStart('StartPointsToRun','bounds','UseParallel','never','Display','off');
[params,residual,flag]=run(searcher,problem,CustomStartPointSet(q0'));


end

