function seq=grating3(x,y,t,ori,sfreq,tfreq,pha)

X=x*cos(ori)+y*sin(ori);
seq=sin(X*sfreq*2*pi+t*tfreq*2*pi+pha);

end
