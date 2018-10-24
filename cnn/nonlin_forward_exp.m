function res_next=nonlin_forward_exp(lay,res,res_next)
    [res_next.x,res_next.aux]=nonlin('exp',res.x,1);
end
