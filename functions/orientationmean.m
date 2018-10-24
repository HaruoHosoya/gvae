function m=orientationmean(oris,weights)
    m=anglemean(mod(oris,pi)*2,weights)/2;
end
