function idx_mat=chairs_find_gt(ds,idx1,idx2)

idx_mat=zeros(length(idx1),length(idx2));

for I=1:length(idx1)
    for J=1:length(idx2)
        idx=find(ds.ids==ds.ids(idx1(I)) & ds.theta==ds.theta(idx2(J)) & ds.phi==ds.phi(idx2(J)));
        if isempty(idx) idx=NaN; end
        idx_mat(I,J)=idx;
    end
end
    
end
