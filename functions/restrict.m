function x=restrict(x,mn,mx)
   
x=(x<=mn).*mn + (mn<x&x<mx).*x + (mx<=x).*mx;

end
