function d=logdet_chol(X)

d=2*sum(log(diag(chol(X))));

end
