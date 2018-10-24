function m=anglemean(angles,weights)
    if ~exist('weights','var')
        m=atan2(nanmean(sin(angles)),nanmean(cos(angles)));
    else
        m=atan2(nansum(sin(angles).*weights/sum(weights)),nansum(cos(angles).*weights/sum(weights)));
    end;
end
