function net=chairs_analyze_model(net,ds)

fprintf('starting to analyze: %s\n',[net.dir_name '/' net.file_name]);

%%%% Few-shot classification

res=vl_simplenn(net.znet_mu,ds.images(:,:,:,ds.test_idx));
tsz=reshape(res(end).x,net.zdim,[]);

res=vl_simplenn(net.znet_pr,ds.images(:,:,:,ds.test_idx));
tsz_pr=reshape(res(end).x,net.zdim,[]);

net.tsz=tsz;
net.tsz_pr=tsz_pr;

%%

net.nsplit=100;
net.nshot=1:10;
net.nshot_sucrate=zeros(length(net.nshot),net.nsplit);
net.nshot_chance=1/length(ds.test_ids);
net.oneshot_view_sucrate=zeros(length(ds.all_theta),length(ds.all_phi),net.nsplit);

for N=1:length(net.nshot)
    fprintf('analyzing %d-shot classification...\n',N);
    gallery={}; probe={};
    for I=1:net.nsplit
        g=[];
        for J=1:length(ds.test_ids)   
            cand=find(ds.ids(ds.test_idx)==ds.test_ids(J));
            g1=cand(randperm(length(cand),net.nshot(N)));
            g=[g;g1(:)];
        end
        gallery{I}=g;
        probe{I}=setdiff(1:length(ds.test_idx),gallery{I});
    end
    [net.nshot_sucrate(N,:),sucidx]=nshot_classify(tsz,tsz_pr,@(idx)ds.ids(ds.test_idx(idx)),gallery,probe,'dist','cosine');

    if N==1
        [it,ip]=ndgrid(ds.all_theta,ds.all_phi);
        for I=1:net.nsplit
            p=probe{I}(sucidx{I});            
            h=arrayfun(@(x)sum(ds.theta(ds.test_idx(p))==it(x) & ds.phi(ds.test_idx(p))==ip(x)),1:length(it(:)));
            p0=probe{I};            
            h0=arrayfun(@(x)sum(ds.theta(ds.test_idx(p0))==it(x) & ds.phi(ds.test_idx(p0))==ip(x)),1:length(it(:)));
            net.oneshot_view_sucrate(:,:,I)=reshape(h./h0,length(ds.all_theta),length(ds.all_phi));
        end
    end        
end

%%

fprintf('analyzing cross-view classification...\n');
gallery={}; probe={};
for I=1:length(ds.all_phi)
    g=[];
    for J=1:length(ds.test_ids)   
        g1=find(ds.ids(ds.test_idx)==ds.test_ids(J) & ds.phi(ds.test_idx)==ds.all_phi(I));
        g=[g;g1(:)];
    end
    gallery{I}=g;
    probe{I}=setdiff(1:length(ds.test_idx),gallery{I});
end
net.crossview_sucrate=nshot_classify(tsz,tsz_pr,@(idx)ds.ids(ds.test_idx(idx)),gallery,probe,'dist','cosine');

%%

fprintf('done.\n');

end
