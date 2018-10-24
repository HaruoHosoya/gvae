function img=grating(x,y,ori,sfreq,pha)

X=x*cos(ori)+y*sin(ori);
img=sin(X*sfreq*2*pi+pha);

end
