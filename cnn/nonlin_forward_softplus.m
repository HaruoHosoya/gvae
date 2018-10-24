function res_next=nonlin_forward_softplus(lay,res,res_next)
    [res_next.x,res_next.aux]=nonlin('softplus',res.x,0.5);
end
