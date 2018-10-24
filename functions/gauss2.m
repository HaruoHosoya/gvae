function g=gauss2(x,y,cx,cy,sigx,sigy)

g=exp(-(x-cx).^2./(2*sigx^2)-(y-cy).^2./(2*sigy^2));

end