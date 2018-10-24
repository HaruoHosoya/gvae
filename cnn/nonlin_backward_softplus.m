function res=nonlin_backward_softplus(lay,res,res_next)
    [~,d]=nonlin('softplus',res.x,0.5);
    res.dzdx=res_next.dzdx.*d;
end
