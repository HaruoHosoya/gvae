function res_next=nonlin_forward_square(lay,res,res_next)
    [res_next.x,res_next.aux]=nonlin('square',res.x,1);
end
