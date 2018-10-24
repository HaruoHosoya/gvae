function Y=nonlinop(X,ty)

switch ty
    case 'square'
        Y=X.^2; 
    case 'abs'
        Y=abs(X); 
    case 'half-square'
        Y=max(0,X).^2; 
    case 'half-rect'
        Y=max(0,X); 
    case 'logcosh'
        Y=log(cosh(X)); 
    case 'tanh'
        Y=tanh(X); 
    case 'sqrt'
        Y=sqrt(X);
    case 'linear'
        Y=X;
    case 'cubic'
        Y=(2*X).^3;
    case 'fifth'
        Y=X.^5/100;
    case 'step'
        Y=(X<0).*0+(X>=0).*1;
    case 'cup'
        Y=(abs(X)<0.1).*((5*X).^2)+(abs(X)>=0.1).*0.25;
    otherwise
        error(['unsupported nonlinearity: ' ty]);
end;

end
