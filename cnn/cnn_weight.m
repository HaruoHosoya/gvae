function W=cnn_weight(w,h,d,n,mag,use_bias,ty)

if ~exist('ty','var') ty='double'; end
if ~exist('use_bias','var') use_bias=false; end

W{1}=mag*randn(w,h,d,n,ty);

if use_bias
    W{2}=zeros(1,32,ty);
else
    W{2}=[];
end

end
