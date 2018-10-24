function h = hellingerdist(dist1,dist2)

s=sum((sqrt(dist1)-sqrt(dist2)).^2);
h=sqrt(s/2);

end