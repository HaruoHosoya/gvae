function [bank,params]=gabor_bank(fieldwid,nx,ny,grid,freq,ori,pha,exponent)

bank=zeros(fieldwid*fieldwid,length(pha),length(ori),length(freq),length(grid),length(grid));
params=zeros(8,length(pha),length(ori),length(freq),length(grid),length(grid));
[x y]=meshgrid(1:fieldwid,1:fieldwid);

maskwid=12;

for YI=1:length(grid)
    for XI=1:length(grid)
        mask=zeros(fieldwid,fieldwid);
%         mask(max(1,grid(YI)-maskwid/2):min(fieldwid,grid(YI)+maskwid/2-1),max(1,grid(XI)-maskwid/2):min(fieldwid,grid(XI)+maskwid/2-1))=1;
        mask(:)=1;
        for FI=1:length(freq)
            for OI=1:length(ori)
                for PI=1:length(pha)
                    sx=nx/freq(FI);
                    sy=ny/freq(FI);
                    params(:,PI,OI,FI,XI,YI)=[grid(XI) grid(YI) 1 sx sy ori(OI) freq(FI) pha(PI)];
                    g=gabor(x,y,params(:,PI,OI,FI,XI,YI));
                    amp=1/sqrt(sum(g(:).^2))*freq(FI)^exponent;
                    bank(:,PI,OI,FI,XI,YI)=g(:).*amp.*mask(:);                    
                end;
            end;
        end;
    end;
end;


end
