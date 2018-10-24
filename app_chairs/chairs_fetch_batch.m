function batch=chairs_fetch_batch(ds,ngroup,nview,ids)

batch=zeros(ds.wid,ds.wid,ds.dep,ngroup,nview);

% content=(id)
% transform=(theta,phi)

for I=1:ngroup
    while(true)
        id=ids(randi(length(ids)));
        cand=find(ds.ids==id);
        if length(cand)>=nview break; end
    end          
    idx=cand(randperm(length(cand),nview));
    batch(:,:,:,I,:)=ds.images(:,:,:,idx);
end

end

