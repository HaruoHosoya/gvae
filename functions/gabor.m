function [G,varargout]=gabor(X,Y,params)
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


XX=(X-x0).*cos(theta)+(Y-y0).*sin(theta);
YY=-(X-x0).*sin(theta)+(Y-y0).*cos(theta);

E=exp(-(XX.^2/(2*sx^2)+YY.^2/(2*sy^2)));
C=cos(2*pi*freq*XX+phi);

EC=E.*C;
G=amp*EC;

G=double(G);

if nargout>=2
    S=sin(2*pi*freq*XX+phi);
    ES=E.*S;
    Gx0    = -amp.*((-cos(theta)/sx^2*XX+sin(theta)/sy^2*YY).*EC-2*pi*freq*cos(theta)*ES);
    Gy0    = amp.*((sin(theta)/sx^2*XX+cos(theta)/sy^2*YY).*EC+2*pi*freq*sin(theta)*ES);
    Gamp   = EC;
    Gsx    = amp/sx^3*XX.^2.*EC;
    Gsy    = amp/sy^3*YY.^2.*EC;
    Gtheta = -amp.*((1/sx^2-1/sy^2)*XX.*YY.*EC+2*pi*freq*YY.*ES);
    Gfreq  = -amp*2*pi*XX.*ES;
    Gphi   = -amp*ES;

    varargout(1)={{Gx0,Gy0,Gamp,Gsx,Gsy,Gtheta,Gfreq,Gphi}};
end;



end

   
