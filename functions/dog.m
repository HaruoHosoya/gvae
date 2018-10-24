function y=dog(x,y,cx,cy,s1,s2,A)

y1=exp(-((x-cx).^2+(y-cy).^2)/(2*s1^2));
y2=exp(-((x-cx).^2+(y-cy).^2)/(2*s2^2));

y2=y2/sum(y2(:))*sum(y1(:));
y=A*(y1-y2);

end
