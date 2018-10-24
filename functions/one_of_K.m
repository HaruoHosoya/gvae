function y=one_of_K(k,K)

y=zeros(K,length(k));
for I=1:length(k)
    y(k(I),I)=1;
end;

end
