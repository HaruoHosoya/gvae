function res_next=nonlin_forward_expsqrt(lay,res,res_next)
    [res_next.x,res_next.aux]=nonlin('expsqrt',res.x,1);
end
