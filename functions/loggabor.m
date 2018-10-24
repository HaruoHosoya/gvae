function [sfilter]=loggabor(width,height,params)
% gabor(x,y,params)
%  params: (x0,y0,amp,sx,sy,theta,freq,phi)
%   where theta gives the orientation of the cosine wave
%           (0: right, pi/2: up, etc in math axis
%         or 0: right, pi/2: down, etc in image axis)

x0=params(1);
y0=params(2);
amp=params(3);
sx=params(4);
sy=params(5);
theta=params(6);
freq=params(7);
phi=params(8);

width2=width*2;
height2=height*2;

[y,x]=meshgrid([-height2/2:(height2/2-1)]/height2,[-width2/2:(width2/2-1)]/width2);

radius=sqrt(x.^2+y.^2);
radius(width2/2+1,height2/2+1)=1;

aspect=sx/sy;
freq_bandwidth=log2((sx.*freq*pi + sqrt(log(2)/2))./(sx.*freq*pi - sqrt(log(2)/2)));
ori_bandwidth=2*asin(aspect*(2^freq_bandwidth-1)/(2^freq_bandwidth+1));

sigmaOnf=exp(-freq_bandwidth/(2*sqrt(2/log(2))));
logGabor = exp((-(log(radius/freq)).^2) / (2 * log(sigmaOnf)^2));
logGabor(width2/2+1, height2/2+1) = 0;

dtheta=anglediff(atan2(y,x),theta);

thetaSigma=ori_bandwidth/(2*sqrt(2*log(2)));

spread = exp((-dtheta.^2) / (2 * thetaSigma^2));

lowpass=atan(-(radius-0.4)*10)/pi+0.5;
lowpass(width2/2+1,height2/2+1)=1;

ffilter = spread.*logGabor.*lowpass;
sfilter=fftshift(ifft2(fftshift(ffilter)));
sfilter=real(sfilter.*exp(1i*phi));
sfilter=sfilter/max(sfilter(:)).*amp;

u0=width+1-x0;
v0=width+1-y0;
sfilter=sfilter(u0:u0+width-1,v0:v0+width-1);

end

   
