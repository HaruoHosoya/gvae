function [f,g]=nonlin(name,x,a,epsilon)

sqrt2=sqrt(2);
sqrt2pi=sqrt(2*pi);

if ~exist('epsilon','var')
    epsilon=1e-120;
end;

switch(name)
    case 'linear'
        f=x;
        g=x.*0+1;
    case 'relu'
        f=(x<0).*epsilon.*x+(x>=0).*x;
        g=(x<0).*epsilon+(x>=0).*1;
    case 'logistic2'
        f=erfc(-x/(sqrt2*a))/2;
        g=(1/(sqrt2pi*a))*exp(-x.^2/(2*a^2));
    case 'logistic2-'
        f=erfc(-x/(sqrt2*a))/2-1/2;
        g=(1/(sqrt2pi*a))*exp(-x.^2/(2*a^2));
    case 'logistic1'
        e=exp(-abs(x)/a);
        f=sign(x).*(1-e)/2+0.5;
        g=e/(2*a);
    case 'softplus'
        e=exp(x/a);
        f=a*log(1+e);
        g=e./(1+e);
    case 'exp'
        e=exp(x);
        f=e;
        g=f;
    case 'expsqrt'
        e=exp(x/2);
        f=e;
        g=f/2;
    case 'square'
        f=x.^2;
        g=2*x;
    otherwise
        error(sprintf('no such nonlinear function: %s',name));
end;
 
end

    