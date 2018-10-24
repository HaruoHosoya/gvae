function [copt, gofopt] = vonmisesFit2(data1)

numinterp=1;

len1=length(data1);
ix1=0:pi/len1:(pi-pi/len1);
cl=fit(ix1',data1,'linearinterp');

len=len1*numinterp;
ix=0:pi/len:(pi-pi/len);
data=cl(ix);

[a0 i0]=max(data);
s0=(i0-1)*pi/len;
s1=mod(s0+pi/2,pi);

opts=fitoptions('Method','NonlinearLeastSquares','Robust','off',...
    'Lower',[0 0 0 0 0 0], 'Upper',[1 1 Inf Inf pi pi],...
    'StartPoint',[a0 a0 1 1 s0 s1],'Display','off');
f=fittype('vonmises(a1,m1,s1,x)+vonmises(a2,m2,s2,x)','options',opts);

[copt,gofopt]=fit(ix',data,f);

end