function res=nonlin_backward_expsqrt(lay,res,res_next)
    [~,d]=nonlin('expsqrt',res.x,1);
    res.dzdx=res_next.dzdx.*d;
end