function [bank,params]=dog_bank(fieldwid,grid,sig_in,sig_out)

bank=zeros(fieldwid*fieldwid,length(grid),length(grid));
[x y]=meshgrid(1:fieldwid,1:fieldwid);

for YI=1:length(grid)
    for XI=1:length(grid)
        g=dog(x,y,grid(XI),grid(YI),sig_in,sig_out,1);
        amp=1/sqrt(sum(g(:).^2));
        bank(:,XI,YI)=g(:).*amp;   
    end;
end;


end
