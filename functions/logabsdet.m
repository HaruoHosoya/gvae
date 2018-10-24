function d=logabsdet(X)

[L,U,P]=lu(X);
d=sum(log(abs(diag(U))));

end
