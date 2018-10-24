function y = vonmises(a,m,x0,x)

y = a*exp(m*(cos(2*(x-x0))-1));

end
