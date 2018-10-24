function res=nonlin_backward_square(lay,res,res_next)
    [~,d]=nonlin('square',res.x,1);
    res.dzdx=res_next.dzdx.*d;
end