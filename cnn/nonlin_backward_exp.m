function res=nonlin_backward_exp(lay,res,res_next)
    [~,d]=nonlin('exp',res.x,1);
    res.dzdx=res_next.dzdx.*d;
end