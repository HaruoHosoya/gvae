function A=linear_interp(width,x,y)

    A=zeros(width,width);
    x0=floor(x); y0=floor(y);
    a=x-x0; b=y-y0;
    R=[(1-a)*(1-b) (1-a)*b; a*(1-b) a*b];
    if x0>=1 && x0<=width && y0>=1 && y0<=width
        A(x0,y0)=R(1,1); end;
    if x0>=0 && x0<=width-1 && y0>=1 && y0<=width
        A(x0+1,y0)=R(2,1); end;
    if x0>=1 && x0<=width && y0>=0 && y0<=width-1
        A(x0,y0+1)=R(1,2); end;
    if x0>=0 && x0<=width-1 && y0>=0 && y0<=width-1
        A(x0+1,y0+1)=R(2,2); end;

end
