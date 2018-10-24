function [copt, gofopt] = gaussFit(x,y)

[a0,xi]=max(y);
a0=a0-min(y);
c0=x(xi);
sig0=(max(x)-min(x))/2;
if max(y)==0 maxa=1; else maxa=max(y); end;

s=fitoptions('Method','NonlinearLeastSquares','Robust','off',...
    'Lower',[0 0 0], 'Upper',[maxa max(x) max(x)-min(x)],...
    'StartPoint',[a0 c0 sig0], 'Display','off');
f=fittype('a*gauss(x,c,sig)','options',s);

[copt,gofopt]=fit(x,y,f);

end

