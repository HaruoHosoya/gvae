function cmap=red_blue_colormap(n)

if ~exist('n','var') n=256; end;

cmap=interp1([0 0 0.5; 0 0 1; 0 0.5 1; 1 1 1; 1 0.5 0; 1 0 0; 0.5 0 0], linspace(1,7,n));

end
