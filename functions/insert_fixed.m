function y=insert_fixed(x,a)
    y=a;
    y(isnan(a))=x;
end
